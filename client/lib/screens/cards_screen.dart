import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_state.dart';

class CardsScreen extends StatefulWidget {
  final GameState game;
  final int myId;
  final void Function(String card, int horseId) onAssign;

  const CardsScreen({
    super.key,
    required this.game,
    required this.myId,
    required this.onAssign,
  });

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final List<String> allCards = ['b1.jpg', 'b2.jpg', 'm1.jpg', 'm2.jpg'];

  final Map<String, String> cardEffects = {
    'b1.jpg': '+2 velocità',
    'b2.jpg': '+3 velocità',
    'm1.jpg': '-2 velocità',
    'm2.jpg': '-3 velocità',
  };

  late List<String> playerDeck;
  int? selectedCardIndex;
  int assignedCardsCount = 0;
  bool doneAssigning = false;

  @override
  void initState() {
    super.initState();
    _generateNewDeck();
  }

  void _generateNewDeck() {
    final rand = Random();
    playerDeck =
        List.generate(3, (_) => allCards[rand.nextInt(allCards.length)]);
    selectedCardIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    if (doneAssigning) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hai finito le carte!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'In attesa che gli altri giocatori completino...',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sfondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          child: Column(
            children: [
              Text(
                'Player ${widget.myId} - ASSEGNA LE 3 CARTE',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(playerDeck.length, (index) {
                  final card = playerDeck[index];
                  final isSelected = selectedCardIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedCardIndex = index),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(6),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.yellow
                                  : Colors.transparent,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/images/$card',
                            width: isSelected ? 70 : 60,
                            height: isSelected ? 120 : 100,
                          ),
                        ),
                        Text(
                          cardEffects[card] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),

              const SizedBox(height: 10),
              const Text(
                'TOCCA UN UNICORNO PER ASSEGNARE',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: Column(
                  children: [
                    for (int i = 0; i < 6; i += 2)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _horseWidget(i + 1),
                          _horseWidget(i + 2),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horseWidget(int horseId) {
    return GestureDetector(
      onTap: selectedCardIndex == null || doneAssigning
          ? null
          : () {
        final card = playerDeck[selectedCardIndex!];

        widget.onAssign(card, horseId);

        setState(() {
          assignedCardsCount++;
          playerDeck.removeAt(selectedCardIndex!);
          selectedCardIndex = null;

          if (assignedCardsCount >= 3) {
            doneAssigning = true;
          } else {
            _generateNewDeck();
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        width: 110,
        height: 140,
        child: Image.asset(
          'assets/images/c$horseId.jpg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
