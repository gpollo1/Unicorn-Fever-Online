import 'package:flutter/material.dart';

class BettingScreen extends StatefulWidget {
  final Function(int, int) onBet;
  final int money;
  final int round;

  const BettingScreen({
    super.key,
    required this.onBet,
    required this.money,
    required this.round,
  });

  @override
  State<BettingScreen> createState() => _BettingScreenState();
}

class _BettingScreenState extends State<BettingScreen> {
  int selectedHorse = 1;
  int betAmount = 10;

  @override
  Widget build(BuildContext context) {
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
              // Round
              Text(
                'Round ${widget.round}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),

              // Soldi totali (stile pulsante leggermente più piccolo)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/banca.png', width: 28, height: 28),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.money} €',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Griglia cavalli 2 per riga
              Column(
                children: [
                  for (int i = 0; i < 6; i += 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _horseWidget(i + 1, selectedHorse),
                        _horseWidget(i + 2, selectedHorse),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Puntata (stile pulsante leggermente più piccolo)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Puntata: $betAmount €',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Image.asset('assets/images/coin.png', width: 36, height: 36),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Slider puntata
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Slider(
                  min: 1,
                  max: widget.money.toDouble(),
                  divisions: widget.money,
                  value: betAmount.toDouble(),
                  activeColor: Colors.yellow,
                  inactiveColor: Colors.grey,
                  onChanged: (v) => setState(() => betAmount = v.toInt()),
                ),
              ),

              const SizedBox(height: 10),

              // Conferma
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  widget.onBet(selectedHorse, betAmount);
                },
                child: const Text(
                  'CONFERMA PUNTATA',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _horseWidget(int id, int selectedHorseId) {
    final bool isSelected = id == selectedHorseId;
    final double width = isSelected ? 160 : 130;
    final double height = isSelected ? 200 : 160;

    return GestureDetector(
      onTap: () => setState(() => selectedHorse = id),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(8),
            width: width,
            height: height,
            transform: isSelected
                ? Matrix4.translationValues(0, -10, 0)
                : Matrix4.identity(),
            child: Image.asset(
              'assets/images/c$id.jpg',
              fit: BoxFit.contain,
            ),
          ),
          if (isSelected)
            Container(
              width: 60,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.yellowAccent,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}