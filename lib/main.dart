import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/note_model.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register NoteModel adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(NoteModelAdapter());
  }

  // Open notes box
  await Hive.openBox<NoteModel>('notesBox');

  // Check how many notes are saved
  print(
    'Hive notes count: ${Hive.box<NoteModel>('notesBox').length}',
  );

  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Notes',
      theme: AppTheme.theme,
      home: const SplashScreen(),
    );
  }
}