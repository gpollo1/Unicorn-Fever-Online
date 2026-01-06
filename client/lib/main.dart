import 'package:flutter/material.dart';

import 'screens/connect_screen.dart';
import 'screens/betting_screen.dart';
import 'screens/race_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/final_results_screen.dart';
import 'network/socket_service.dart';
import 'models/game_state.dart';

void main() {
  runApp(const UnicornFeverApp());
}

class UnicornFeverApp extends StatelessWidget {
  const UnicornFeverApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameRoot(),
    );
  }
}

class GameRoot extends StatefulWidget {
  const GameRoot({super.key});

  @override
  State<GameRoot> createState() => _GameRootState();
}

class _GameRootState extends State<GameRoot> {
  final SocketService socket = SocketService();

  GameState? game;
  int? myId;
  bool connected = false;

  @override
  void dispose() {
    socket.close();
    super.dispose();
  }

  Future<void> connect() async {
    await socket.connect(
      onAssign: (id) {
        if (mounted) setState(() => myId = id);
      },
      onState: (g) {
        if (mounted) setState(() => game = g);
      },
    );

    if (mounted) setState(() => connected = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!connected) return ConnectScreen(onConnect: connect);

    if (game == null || myId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final me = game!.players.firstWhere(
          (p) => p.id == myId,
      orElse: () => game!.players.first,
    );

    switch (game!.phase) {
      case GamePhase.waitingPlayers:
        return const Scaffold(
          body: Center(
            child: Text(
              'In attesa di altri giocatori...',
              style: TextStyle(fontSize: 24),
            ),
          ),
        );

      case GamePhase.betting:
        return BettingScreen(
          money: me.money,
          round: game!.round,
          onBet: (horse, amount) {
            socket.send({
              'type': 'bet',
              'horse': horse,
              'amount': amount,
            });
          },
        );

      case GamePhase.cards:
        return CardsScreen(
          game: game!,
          myId: myId!,
          onAssign: (card, horseId) {
            socket.send({
              'type': 'assign_card',
              'card': card,
              'horse': horseId,
            });
          },
        );

      case GamePhase.race:
        return RaceScreen(
          game: game!,
          socket: socket,
          myId: myId!,
        );

      case GamePhase.results:
        if (game!.gameFinished) {
          // Se il server ha segnalato che il gioco è finito
          return FinalResultsScreen(game: game!);
        } else {
          // Mostra la schermata dei risultati della corsa del round corrente
          return RaceScreen(
            game: game!,
            socket: socket,
            myId: myId!,
          );
        }
    }
  }
}


