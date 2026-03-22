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

      String category = "others";
      String lowerName = name.toLowerCase();
      if (lowerName.contains("upi")||
          lowerName.contains("pay")||
          lowerName.contains("reciept")){
        category = "Payments";
      } else if (lowerName.contains("Amazon")||
      lowerName.contains("orders")){
        category = "Orders";
      } else if (lowerName.contains("Certificates")){
        category = "Academic";
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