import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';

class FolderScreen extends StatefulWidget {
  final String title;

  const FolderScreen({
    super.key,
    required this.title,
  });

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {

  List<Map<String, String>> documents = [];

  @override
  void initState() {
    super.initState();
    loadDocuments();
  }

  void loadDocuments() {
    final box = Hive.box('documentsBox');

    setState(() {
      documents = box.values
          .map((e) => Map<String, String>.from(e))
          .where((doc) => doc["category"] == widget.title)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('documentsBox');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              final allItems = box.values.toList();

              for (int i = allItems.length - 1; i >= 0; i--) {
                final item = Map<String, String>.from(allItems[i]);

                if (item["category"] == widget.title) {
                  box.deleteAt(i);
                }
              }

              loadDocuments();
            },
          )
        ],
      ),

      body: documents.isEmpty
          ? const Center(child: Text("No files here"))
          : ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];

          return Dismissible(
            key: Key("${doc["name"]}_${index}"),
            direction: DismissDirection.startToEnd,

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            onDismissed: (direction) {
              final box = Hive.box('documentsBox');

              final allItems = box.values.toList();

              for (int i = 0; i < allItems.length; i++) {
                final item = Map<String, String>.from(allItems[i]);

                if (item["name"] == doc["name"] &&
                    item["category"] == doc["category"]) {
                  box.deleteAt(i);
                  break;
                }
              }

              loadDocuments();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted successfully")),
              );
            },

            child: ListTile(
              onTap: () {
                OpenFile.open(doc["path"]!);
              },
              leading: const Icon(Icons.insert_drive_file),
              title: Text(doc["name"]!),
              subtitle: Text(doc["category"]!),
            )
          );
        },
      ),
    );
  }
}