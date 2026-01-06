import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

// --- MODELLI ---
class Player {
  final int id;
  int money = 100;
  int? betHorse;
  int? betAmount;
  int assignedCards = 0;

  Player(this.id);

  bool get readyBet => betHorse != null && betAmount != null;
  bool get finishedCards => assignedCards >= 3;

  Map<String, dynamic> toJson() => {
    'id': id,
    'money': money,
    'betHorse': betHorse,
    'betAmount': betAmount,
    'assignedCards': assignedCards,
  };
}

enum CardType { bonus, malus }

class CardEffect {
  final String name;
  final CardType type;
  final int value;
  final String imagePath;

  CardEffect({
    required this.name,
    required this.type,
    required this.value,
    required this.imagePath,
  });
}

class Horse {
  final int id;
  double position = 0;
  int bonus = 0;
  final Random _rnd = Random();

  Horse(this.id);

  void applyCard(CardEffect card) {
    bonus += (card.type == CardType.bonus ? card.value : -card.value);
  }

  double step() => _rnd.nextDouble() * 3 + 1 + bonus;

  void reset() {
    position = 0;
    bonus = 0;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'position': position,
  };
}

enum GamePhase { waitingPlayers, betting, cards, race, results }

class GameState {
  List<Player> players = [];
  List<Horse> horses = List.generate(6, (i) => Horse(i + 1));
  List<CardEffect> deck = [];

  GamePhase phase = GamePhase.waitingPlayers;
  int round = 1;
  final int maxRounds = 3;

  // ✅ Flag per indicare fine gioco
  bool gameFinished = false;

  final Random _rnd = Random();

  GameState() {
    deck = [
      CardEffect(name: 'B1', type: CardType.bonus, value: 2, imagePath: 'b1.jpg'),
      CardEffect(name: 'B2', type: CardType.bonus, value: 3, imagePath: 'b2.jpg'),
      CardEffect(name: 'M1', type: CardType.malus, value: 2, imagePath: 'm1.jpg'),
      CardEffect(name: 'M2', type: CardType.malus, value: 3, imagePath: 'm2.jpg'),
    ];
  }

  bool get allReadyBet => players.every((p) => p.readyBet);
  bool get allCardsAssigned => players.every((p) => p.finishedCards);

  void assignCardToHorse({
    required int playerId,
    required String cardImage,
    required int horseId,
  }) {
    final player = players.firstWhere((p) => p.id == playerId);
    if (player.finishedCards) return;

    final card = deck.firstWhere((c) => c.imagePath == cardImage);
    final horse = horses.firstWhere((h) => h.id == horseId);

    horse.applyCard(card);
    player.assignedCards++;
  }

  Future<void> runRaceStepByStep(Function broadcast) async {
    final double finishLine = 400;
    bool finished = false;

    while (!finished) {
      await Future.delayed(const Duration(milliseconds: 200));
      finished = true;
      for (var h in horses) {
        if (phase != GamePhase.race) continue;
        h.position += h.step();
        if (h.position < finishLine) finished = false;
      }
      broadcast(this);
      if (horses.every((h) => h.position >= finishLine)) finished = true;
    }
  }

  void resolveBets() {
    horses.sort((a, b) => b.position.compareTo(a.position));
    final winner = horses.first.id;

    for (var p in players) {
      if (p.betHorse == winner) {
        p.money += p.betAmount!;
      } else {
        p.money -= p.betAmount!;
      }
    }
  }

  void nextRound() {
    round++;
    for (var h in horses) h.reset();
    for (var p in players) {
      p.betHorse = null;
      p.betAmount = null;
      p.assignedCards = 0;
    }
    phase = GamePhase.betting;
  }

  // ✅ UNICO toJson con gameFinished
  Map<String, dynamic> toJson() => {
    'phase': phase.name,
    'round': round,
    'players': players.map((p) => p.toJson()).toList(),
    'horses': horses.map((h) => h.toJson()).toList(),
    'gameFinished': gameFinished,
  };
}

// --- SERVER ---
void main() async {
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
  final game = GameState();
  final clients = <Socket>[];
  final Set<int> playersReadyNext = {};

  print('🟢 Server avviato sulla porta 3000');

  server.listen((Socket client) {
    final id = game.players.length;
    final player = Player(id);

    game.players.add(player);
    clients.add(client);

    if (game.players.length >= 2 && game.phase == GamePhase.waitingPlayers) {
      game.phase = GamePhase.betting;
    }

    client.write(jsonEncode({'type': 'assign', 'playerId': id}) + '\n');
    broadcast(game, clients);

    client
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) async {
      try {
        final msg = jsonDecode(line);

        // --- BET ---
        if (msg['type'] == 'bet' && game.phase == GamePhase.betting) {
          player.betHorse = msg['horse'];
          player.betAmount = msg['amount'];
          if (game.allReadyBet) {
            game.phase = GamePhase.cards;
            broadcast(game, clients);
          }
        }

        // --- ASSIGN CARD ---
        if (msg['type'] == 'assign_card' && game.phase == GamePhase.cards) {
          game.assignCardToHorse(
              playerId: player.id, cardImage: msg['card'], horseId: msg['horse']);

          if (game.allCardsAssigned) {
            game.phase = GamePhase.race;
            broadcast(game, clients);

            await game.runRaceStepByStep((g) => broadcast(g, clients));

            game.resolveBets();
            game.phase = GamePhase.results;
            broadcast(game, clients);

            playersReadyNext.clear();
          }
        }

        // --- CORSA
        if (msg['type'] == 'raceFinished' && game.phase == GamePhase.race) {
          print('DEBUG SERVER: Ricevuto raceFinished, fermo cavalli');

          // Aggiorna le posizioni dei cavalli secondo il client
          final horsePositions = List<double>.from(msg['horsesPositions'] ?? []);
          for (int i = 0; i < horsePositions.length && i < game.horses.length; i++) {
            game.horses[i].position = horsePositions[i];
          }

          // Risolvi le scommesse
          game.resolveBets();

          // Passa alla fase risultati
          game.phase = GamePhase.results;
          broadcast(game, clients);

          // Pulisce lista di chi ha premuto next
          playersReadyNext.clear();
        }

        // --- NEXT ROUND ---
        if (msg['type'] == 'next' && game.phase == GamePhase.results) {
          playersReadyNext.add(player.id);
          print('DEBUG SERVER: Player ${player.id} pronto next');

          if (playersReadyNext.length == game.players.length) {
            if (game.round < game.maxRounds) {
              game.nextRound();
              broadcast(game, clients);
            } else {
              // ✅ Ultimo round terminato
              print('🏁 Gioco terminato');
              game.gameFinished = true; // <-- setta qui
              broadcast(game, clients); // notifica tutti i client
            }
            playersReadyNext.clear();
          }
        }
        broadcast(game, clients);
      } catch (e) {
        print('Errore parsing messaggio: $e');
      }
    }, onDone: () {
      clients.remove(client);
      client.destroy();
    });
  });
}

// --- BROADCAST ---
void broadcast(GameState game, List<Socket> clients) {
  final msg = jsonEncode({'type': 'state', 'game': game.toJson()}) + '\n';
  for (var c in clients) {
    try {
      c.write(msg);
    } catch (_) {}
  }
}