import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note_model.dart';
import '../services/hive_service.dart';
import '../widgets/delete_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String searchText = '';

  Future<void> showNoteDialog({NoteModel? note}) async {
    final titleController = TextEditingController(
      text: note?.title ?? '',
    );

    final contentController = TextEditingController(
      text: note?.content ?? '',
    );

    final isEditing = note != null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            isEditing ? 'Edit Note' : 'Add Note',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF172033),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    prefixIcon: Icon(
                      Icons.title_rounded,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Write your note...',
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 70),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                final content = contentController.text.trim();

                if (title.isEmpty || content.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter title and note'),
                    ),
                  );
                  return;
                }

                if (isEditing) {
                  note.title = title;
                  note.content = content;
                  note.date = DateTime.now();

                  await HiveService.updateNote(note);
                } else {
                  final newNote = NoteModel(
                    title: title,
                    content: content,
                    date: DateTime.now(),
                  );

                  await HiveService.addNote(newNote);
                }

                if (mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Add Note',
              ),
            ),
          ],
        );
      },
    );

    titleController.dispose();
    contentController.dispose();
  }

  Future<void> deleteNote(NoteModel note) async {
    await HiveService.deleteNote(note);
  }

  Future<void> deleteAllNotes() async {
    await HiveService.deleteAllNotes();
  }

  Future<void> togglePin(NoteModel note) async {
    await HiveService.togglePin(note);
  }

  String formatDate(DateTime date) {
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
            ? 12
            : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '${date.day}/${date.month}/${date.year} • $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete_all') {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DeleteDialog(
                      title: 'Delete All Notes',
                      message:
                          'Are you sure you want to delete all notes?',
                      onDelete: deleteAllNotes,
                    );
                  },
                );
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'delete_all',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_sweep_outlined,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text('Delete All'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable: HiveService.box.listenable(),
        builder: (context, Box<NoteModel> box, _) {
          List<NoteModel> notes = box.values.toList();

          notes = notes.where((note) {
            final title = note.title.toLowerCase();
            final content = note.content.toLowerCase();
            final search = searchText.toLowerCase();

            return title.contains(search) ||
                content.contains(search);
          }).toList();

          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) {
              return -1;
            }

            if (!a.isPinned && b.isPinned) {
              return 1;
            }

            return b.date.compareTo(a.date);
          });

          return Column(
            children: [
              // Welcome section
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  8,
                  20,
                  15,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مرحباً عبدالله 👋',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172033),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'إيه اللي محتاج تفتكره النهارده؟',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF1565C0),
                    ),
                    suffixIcon: searchText.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                searchText = '';
                              });
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Notes
              Expanded(
                child: notes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFEAF3FF),
                                borderRadius:
                                    BorderRadius.circular(22),
                              ),
                              child: const Icon(
                                Icons.note_alt_outlined,
                                size: 38,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'No Notes Yet',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Create your first note',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          5,
                          20,
                          100,
                        ),
                        itemCount: notes.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          return Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade200,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                // Note icon
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF3FF),
                                    borderRadius:
                                        BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    note.isPinned
                                        ? Icons.push_pin_rounded
                                        : Icons
                                            .description_outlined,
                                    color:
                                        const Color(0xFF1565C0),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Note content
                                Expanded(
                                  child: InkWell(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    onTap: () {
                                      showNoteDialog(note: note);
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                note.title,
                                                maxLines: 1,
                                                overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                style:
                                                    const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  color:
                                                      Color(0xFF172033),
                                                ),
                                              ),
                                            ),
                                            if (note.isPinned)
                                              const Icon(
                                                Icons.push_pin,
                                                size: 16,
                                                color:
                                                    Color(0xFF1565C0),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          note.content,
                                          maxLines: 2,
                                          overflow:
                                              TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Colors.grey.shade600,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          formatDate(note.date),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color:
                                                Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Edit button
                                IconButton(
                                  tooltip: 'Edit',
                                  onPressed: () {
                                    showNoteDialog(note: note);
                                  },
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: Color(0xFF1565C0),
                                    size: 21,
                                  ),
                                ),

                                // More button
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'pin') {
                                      togglePin(note);
                                    }

                                    if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return DeleteDialog(
                                            title: 'Delete Note',
                                            message:
                                                'Are you sure you want to delete this note?',
                                            onDelete: () {
                                              deleteNote(note);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'pin',
                                        child: Row(
                                          children: [
                                            Icon(
                                              note.isPinned
                                                  ? Icons
                                                      .push_pin_outlined
                                                  : Icons
                                                      .push_pin,
                                              color:
                                                  const Color(
                                                0xFF1565C0,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
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
                                              Icons
                                                  .delete_outline,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: 10),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNoteDialog();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}