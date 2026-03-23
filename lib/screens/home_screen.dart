import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'add_document_screen.dart';
import 'folder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Evidence Locker",
          style: TextStyle(
            color: Color(0xFF6F4E37),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Welcome back, Tanya 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6F4E37),
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Secure. Smart. Organized.",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 30),

            // 📂 FOLDER GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  buildFolderCard("Payments", Icons.payment, Colors.green),
                  buildFolderCard("Screenshots", Icons.image, Colors.purple),
                  buildFolderCard("Images", Icons.photo, Colors.teal),
                  buildFolderCard("Academic", Icons.school, Colors.blue),
                  buildFolderCard("Bills", Icons.receipt_long, Colors.redAccent),
                  buildFolderCard("Others", Icons.folder, Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6F4E37),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddDocumentScreen(),
            ),
          );

          if (result != null) {
            final box = Hive.box('documentsBox');

            setState(() {
              documents.add(result);
              box.add(result);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // 📂 Folder Card UI
  Widget buildFolderCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        final filtered = documents.where((doc) {
          return doc["category"] == title;
        }).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderScreen(
              title: title,
              documents: filtered,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF2E2E2E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}