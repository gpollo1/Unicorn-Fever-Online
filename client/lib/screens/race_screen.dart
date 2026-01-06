import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../network/socket_service.dart';
import 'results_screen.dart';

class RaceScreen extends StatefulWidget {
  final GameState game;
  final SocketService socket;
  final int myId;

  const RaceScreen({
    super.key,
    required this.game,
    required this.socket,
    required this.myId,
  });

  @override
  _RaceScreenState createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _horseAnimations;
  late List<double> horsePositions;
  final double trackLength = 600.0;

  bool raceFinished = false;
  bool pressedNext = false;

  @override
  void initState() {
    super.initState();

    horsePositions = widget.game.horses.map((h) => h.position).toList();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _horseAnimations = widget.game.horses.map((h) {
      final end = trackLength;
      return Tween<double>(begin: h.position, end: end)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    }).toList();

    _controller.addListener(() {
      setState(() {
        for (int i = 0; i < horsePositions.length; i++) {
          horsePositions[i] = _horseAnimations[i].value;
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !raceFinished) {
        _stopRaceAndShowResults();
      }
    });

    _controller.forward();
  }

  /// Funzione per fermare la corsa e mostrare i risultati
  void _stopRaceAndShowResults() {
    if (raceFinished) return;

    setState(() {
      raceFinished = true;
      for (int i = 0; i < widget.game.horses.length; i++) {
        widget.game.horses[i].position = horsePositions[i];
      }
    });

    // Invia al server che la corsa è finita
    widget.socket.send({
      'type': 'raceFinished',
      'horsesPositions': horsePositions,
      'playerId': widget.myId,
    });
  }

  void onPressNext() {
    if (pressedNext) return;
    pressedNext = true;

    widget.socket.send({'type': 'next', 'playerId': widget.myId});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Se la fase del gioco è results, blocco l'animazione e mostro i risultati
    if (widget.game.phase == GamePhase.results && !raceFinished) {
      _controller.stop();
      _stopRaceAndShowResults();
    }

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/sfondo-gara.png', fit: BoxFit.cover),
        ),
        ...horsePositions.asMap().entries.map((entry) {
          final i = entry.key;
          final pos = entry.value;
          final horse = widget.game.horses[i];
          return Positioned(
            left: pos,
            top: 50.0 + i * 100,
            child: Image.asset(
              'assets/images/cc${horse.id}.png',
              width: 80,
              height: 80,
            ),
          );
        }).toList(),
        if (raceFinished)
          ResultsScreen(
            game: widget.game,
            onNext: onPressNext,
          ),
      ],
    );
  }
}