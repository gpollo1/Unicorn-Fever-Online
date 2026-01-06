import 'player.dart';
import 'horse.dart';

enum GamePhase {
  waitingPlayers,
  betting,
  cards,
  race,
  results,
}

class GameState {
  GamePhase phase;
  int round;
  List<Player> players;
  List<Horse> horses;
  final int maxRounds = 3;

  // ✅ Nuovo flag per sapere se il gioco è finito
  bool gameFinished;

  GameState({
    required this.phase,
    required this.round,
    required this.players,
    required this.horses,
    this.gameFinished = false, // default false
  });

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      phase: GamePhase.values.firstWhere(
            (e) => e.name == json['phase'],
      ),
      round: json['round'],
      players: (json['players'] as List)
          .map((p) => Player.fromJson(p))
          .toList(),
      horses: (json['horses'] as List)
          .map((h) => Horse.fromJson(h))
          .toList(),
      gameFinished: json['gameFinished'] ?? false, // legge dal server
    );
  }

  Map<String, dynamic> toJson() => {
    'phase': phase.name,
    'round': round,
    'players': players.map((p) => p.toJson()).toList(),
    'horses': horses.map((h) => h.toJson()).toList(),
    'gameFinished': gameFinished,
  };
}