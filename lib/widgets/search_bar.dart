import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search notes...',
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xFF1565C0),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.tune_rounded),
          onPressed: () {},
        ),
      ),
    );
  }
}