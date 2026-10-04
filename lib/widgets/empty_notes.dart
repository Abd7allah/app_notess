import 'package:flutter/material.dart';

class EmptyNotes extends StatelessWidget {
  const EmptyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.note_alt_outlined,
              size: 60,
              color: Color(0xFF1565C0),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'No Notes Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Create your first note',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}