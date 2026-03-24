import 'package:flutter/material.dart';

class FolderScreen extends StatelessWidget {
  final String title;
  final List documents;
  final String searchQuery;

  const FolderScreen({
    super.key,
    required this.title,
    required this.documents,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    final filteredDocs = documents.where((doc) {
      return doc["name"]
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: documents.isEmpty
          ? const Center(child: Text("No files here"))
          : ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];

          return ListTile(
            leading: const Icon(Icons.insert_drive_file),
            title: Text(doc["name"]),
            subtitle: Text(doc["category"]),
          );
        },
      ),
    );
  }
}