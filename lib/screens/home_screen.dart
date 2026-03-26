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
  String searchQuery = "";
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
        centerTitle: true,
        title: const Text(
          "Evidence Locker",
          style: TextStyle(
            color: Color(0xFF6F4E37),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
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
            TextField(
              decoration: InputDecoration(
                hintText: "Search documents...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 20),
            Expanded(
              child: searchQuery.isNotEmpty
                  ? ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];

                  final name = doc["name"]!.toLowerCase();
                  final category = doc["category"]!.toLowerCase();
                  final query = searchQuery.toLowerCase();

                  if (!(name.contains(query) ||
                      category.contains(query))) {
                    return const SizedBox();
                  }

                  return ListTile(
                    title: Text(doc["name"]!),
                    subtitle: Text(doc["category"]!),
                  );
                },
              )
                  : GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  buildFolderCard("Payments", Icons.payment, Colors.green),
                  buildFolderCard("Screenshots", Icons.image, Colors.purple),
                  buildFolderCard("Images", Icons.photo, Colors.teal),
                  buildFolderCard("Academic", Icons.school, Colors.blue),
                  buildFolderCard("Bills", Icons.receipt_long, Colors.redAccent),
                  buildFolderCard("IDs", Icons.badge, Colors.indigo),
                  buildFolderCard("Tickets", Icons.confirmation_number, Colors.pink),
                  buildFolderCard("Others", Icons.folder, Colors.grey),
                ],
              ),
            )
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
          loadDocuments();

          if (result != null) {
            final box = Hive.box('documentsBox');
            box.add(result);
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
  Widget buildFolderCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderScreen(
              title: title,
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