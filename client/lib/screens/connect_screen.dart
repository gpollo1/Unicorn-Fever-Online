import 'package:flutter/material.dart';

class ConnectScreen extends StatelessWidget {
  final VoidCallback onConnect;

  const ConnectScreen({super.key, required this.onConnect});

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
        child: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 20,
              ),
            ),
            onPressed: onConnect,
            child: const Text(
              'CONNETTITI',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}