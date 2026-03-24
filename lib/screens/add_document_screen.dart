import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String name = result.files.single.name;
      String path = result.files.single.path!;

      String category = "Others";
      String lowerName = name.toLowerCase();
      if (lowerName.contains("screenshot")) {
        category = "Screenshots";
      }
      else if (lowerName.contains("img") ||
          lowerName.contains("photo") ||
          lowerName.endsWith(".jpg") ||
          lowerName.endsWith(".png")) {
        category = "Images";
      }
      else if (lowerName.contains("upi") ||
          lowerName.contains("pay") ||
          lowerName.contains("receipt")||
          lowerName.contains("Gpay")){
        category = "Payments";
      }
      else if (lowerName.contains("bill") ||
          lowerName.contains("invoice")) {
        category = "Bills";
      }
      else if (lowerName.contains("certificate") ||
          lowerName.contains("result")) {
        category = "Academic";
      }
      else if (lowerName.contains("aadhaar") ||
          lowerName.contains("pan") ||
          lowerName.contains("id")) {
        category = "IDs";
      }
      else if (lowerName.contains("ticket") ||
          lowerName.contains("booking")) {
        category = "Tickets";
      }
      Navigator.pop(context, {
        "name": name,
        "path": path,
        "category": category,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Document"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: pickFile,
          child: const Text("Pick File"),
        ),
      ),
    );
  }
}