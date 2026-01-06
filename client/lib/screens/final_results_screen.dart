import 'package:flutter/material.dart';
import '../models/game_state.dart';

class FinalResultsScreen extends StatelessWidget {
  final GameState game;

  const FinalResultsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Trova il massimo denaro
    final maxMoney = game.players.map((p) => p.money).reduce((a, b) => a > b ? a : b);
    // Tutti i vincitori (nel caso di pareggio)
    final winners = game.players.where((p) => p.money == maxMoney).toList();

    return Scaffold(
      body: Container(
        color: Colors.black87,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🏁 GIOCO TERMINATO 🏁',
              style: TextStyle(
                  fontSize: 32, color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Text(
              winners.length == 1
                  ? 'Il vincitore è il Player ${winners.first.id}!'
                  : 'Pareggio tra: ${winners.map((p) => "Player ${p.id}").join(", ")}',
              style: const TextStyle(
                  fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Soldi finali:',
              style: TextStyle(fontSize: 22, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            ...game.players.map((p) => Text(
              'Player ${p.id}: ${p.money} €',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            )),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Chiude l'app o torna alla schermata iniziale
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                child: Text('TORNA ALL\'INIZIO', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}