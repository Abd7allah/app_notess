import 'package:flutter/material.dart';

import '../models/note_model.dart';
import '../services/hive_service.dart';

class NoteDetailsScreen extends StatefulWidget {
  final NoteModel note;

  const NoteDetailsScreen({
    super.key,
    required this.note,
  });

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note.title,
    );

    contentController = TextEditingController(
      text: widget.note.content,
    );
  }

  Future<void> updateNote() async {
    widget.note.title = titleController.text.trim();

    widget.note.content = contentController.text.trim();

    widget.note.date = DateTime.now();

    await HiveService.updateNote(widget.note);

    if (!mounted) return;

    Navigator.pop(context);
  }

  Future<void> togglePin() async {
    await HiveService.togglePin(widget.note);

    setState(() {});
  }

  Future<void> deleteNote() async {
    await HiveService.deleteNote(widget.note);

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
          'Edit Note',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            onPressed: togglePin,
            icon: Icon(
              widget.note.isPinned
                  ? Icons.push_pin
                  : Icons.push_pin_outlined,

              color: const Color(0xFF1565C0),
            ),
          ),

          IconButton(
            onPressed: () {
              showDialog(
                context: context,

                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                      'Delete Note',
                    ),

                    content: const Text(
                      'Are you sure you want to delete this note?',
                    ),

                    actions: [

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('Cancel'),
                      ),

                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);

                          await deleteNote();
                        },

                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },

            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
            ),
          ),

          IconButton(
            onPressed: updateNote,

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