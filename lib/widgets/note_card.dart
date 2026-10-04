import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onPin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
    required this.onPin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: Colors.blue.shade50,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                if (note.isPinned)
                  const Icon(
                    Icons.push_pin,
                    size: 17,
                    color: Color(0xFF1565C0),
                  ),

                if (note.isPinned)
                  const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172033),
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'pin') {
                      onPin();
                    }

                    if (value == 'delete') {
                      onDelete();
                    }
                  },

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'pin',
                      child: Row(
                        children: [
                          Icon(
                            note.isPinned
                                ? Icons.push_pin_outlined
                                : Icons.push_pin,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            note.isPinned
                                ? 'Unpin'
                                : 'Pin',
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            Expanded(
              child: Text(
                note.content,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '${note.date.day}/${note.date.month}/${note.date.year}',

              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}