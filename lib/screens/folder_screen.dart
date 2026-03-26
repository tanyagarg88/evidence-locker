import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'image_preview_screen.dart';

class
FolderScreen extends StatefulWidget {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Color(0xFF6F4E37),
            fontWeight: FontWeight.bold,
          ),
        ),
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
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.folder_open, size: 60, color: Colors.brown),
            SizedBox(height: 10),
            Text(
              "No files here",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      )
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
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                  borderRadius: BorderRadius.circular(20),onTap: () async {
                String path = doc["path"]!;

                if (path.endsWith(".jpg") || path.endsWith(".png")) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImagePreviewScreen(imagePath: path),
                    ),
                  );
                } else {
                  OpenFile.open(path);
                }
              },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.12),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      doc["path"]!.endsWith(".pdf")
                          ? Icons.picture_as_pdf
                          : Icons.image,
                      size: 26,
                      color: doc["path"]!.endsWith(".pdf")
                          ? Colors.red
                          : Colors.purple,
                    ),
                  ),

                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doc["name"]!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          doc["category"]!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  const Icon(Icons.more_vert, color: Colors.grey),
                ],
              ),
            ),
              ),
            ),
          );
        },
      ),
    );
  }
}