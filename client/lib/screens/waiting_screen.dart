import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'In attesa di altri giocatori...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}