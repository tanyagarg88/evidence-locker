import 'package:flutter/material.dart';
import 'add_document_screen.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> documents = [];
  String searchQuery = "";

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

    final filteredDocs = documents.where((doc) {
      return doc["name"]!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EDE4),
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
              "Your personal digital vault",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 25),

            TextField(
              decoration: InputDecoration(
                hintText: "Search documents...",
                prefixIcon: const Icon(Icons.search, color: Color(0xFF6F4E37)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
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
              child: filteredDocs.isEmpty
                  ? Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    "No documents found",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];

                  IconData icon;
                  Color iconColor;

                  switch (doc["category"]) {
                    case "Payments":
                      icon = Icons.payment;
                      iconColor = Colors.green;
                      break;
                    case "Orders":
                      icon = Icons.shopping_bag;
                      iconColor = Colors.orange;
                      break;
                    case "Academic":
                      icon = Icons.school;
                      iconColor = Colors.blue;
                      break;
                    case "Screenshots":
                      icon = Icons.image;
                      iconColor = Colors.purple;
                      break;
                    default:
                      icon = Icons.insert_drive_file;
                      iconColor = Colors.grey;
                  }

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: iconColor, size: 22),
                        ),

                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc["name"] ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Color(0xFF2E2E2E),
                                ),
                              ),

                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    doc["category"] ?? "Others",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: iconColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  const Spacer(),
                                  Text(
                                    "Saved",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF6F4E37),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddDocumentScreen(),
              ),
            );

            if (result != null) {
              setState(() {
                documents.add(result);
                final box = Hive.box('documentsBox');
                box.add(result);
              });
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}