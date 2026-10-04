import 'dart:async';

import 'package:flutter/material.dart';

import 'notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const NotesScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              width: 100,
              height: 100,

              decoration: BoxDecoration(
                color: const Color(0xFFEAF3FF),
                borderRadius: BorderRadius.circular(28),
              ),

              child: const Icon(
                Icons.note_alt_rounded,
                size: 55,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'My Notes',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Keep your ideas organized',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 35),

            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color(0xFF1565C0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}