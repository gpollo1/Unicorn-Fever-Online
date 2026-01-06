import 'package:flutter/material.dart';

class HorseCard extends StatelessWidget {
  final int horseId;
  final VoidCallback onTap;

  const HorseCard({
    super.key,
    required this.horseId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Center(
          child: Text(
            '🦄 $horseId',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}