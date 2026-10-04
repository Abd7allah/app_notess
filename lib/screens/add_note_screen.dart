import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/hive_service.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  Future<void> saveNote() async {
    if (titleController.text.trim().isEmpty &&
        contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Write something first'),
        ),
      );

      return;
    }

    final note = NoteModel(
      title: titleController.text.trim().isEmpty
          ? 'Untitled Note'
          : titleController.text.trim(),

      content: contentController.text.trim(),

      date: DateTime.now(),

      isPinned: false,
    );

    await HiveService.addNote(note);

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'New Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(
              Icons.check,
              color: Color(0xFF1565C0),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: titleController,

              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),

              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                filled: false,
              ),
            ),

            const Divider(),

            Expanded(
              child: TextField(
                controller: contentController,

                expands: true,
                maxLines: null,

                textAlignVertical: TextAlignVertical.top,

                decoration: const InputDecoration(
                  hintText: 'Write your note...',
                  border: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}