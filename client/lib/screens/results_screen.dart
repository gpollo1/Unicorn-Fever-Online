import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../models/horse.dart';

class ResultsScreen extends StatelessWidget {
  final GameState game;
  final VoidCallback onNext;

  const ResultsScreen({super.key, required this.game, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final horses = List<Horse>.from(game.horses)
      ..sort((a, b) => b.position.compareTo(a.position));
    final positions = {for (int i = 0; i < horses.length; i++) horses[i].id: i + 1};

    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.75),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              '🏆 RISULTATI DELLA CORSA 🏆',
              style: TextStyle(
                  fontSize: 28, color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...horses.map((h) => Card(
                      color: Colors.white10,
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      child: ListTile(
                        leading: Image.asset('assets/images/cc${h.id}.png', width: 40),
                        title: Text('Cavallo ${h.id}',
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                        trailing: Text('${positions[h.id]}°',
                            style: const TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    )),
                    const Divider(color: Colors.white70),
                    ...game.players.map((p) {
                      final winnerHorse = horses.first.id;
                      final won = p.betHorse == winnerHorse;
                      final diff = won ? p.betAmount! : -p.betAmount!;
                      return Card(
                        color: won ? Colors.green[700] : Colors.red[700],
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                        child: ListTile(
                          leading: Image.asset('assets/images/cc${p.betHorse}.png', width: 40),
                          title: Text('Player ${p.id}',
                              style: const TextStyle(color: Colors.white, fontSize: 16)),
                          subtitle: Text(
                              'Cavallo ${p.betHorse} • ${positions[p.betHorse]}°',
                              style: const TextStyle(color: Colors.white70)),
                          trailing: Text(diff > 0 ? '+$diff €' : '$diff €',
                              style: const TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12)),
                onPressed: () {
                  print("DEBUG: Bottone PROSSIMO ROUND premuto!");
                  onNext();
                },
                child: const Text('PROSSIMO ROUND', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}