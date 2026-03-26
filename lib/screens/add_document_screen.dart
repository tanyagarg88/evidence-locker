import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {
  Future<void> scanDocument() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      String path = image.path;
      String name = path.split('/').last;

      String extractedText = await extractText(path);
      print("OCR: $extractedText");

      String text = extractedText.toLowerCase();
      String category = "Others";

      if (text.contains("upi") || text.contains("₹")) {
        category = "Payments";
      } else if (text.contains("bill")) {
        category = "Bills";
      } else if (text.contains("certificate")) {
        category = "Academic";
      }
      Navigator.pop(context, {
        "name": name,
        "path": path,
        "category": category,
      });
    }
  }

  Future<String> extractText(String path) async {
    final textRecognizer = TextRecognizer();
    final inputImage = InputImage.fromFilePath(path);

    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);

    await textRecognizer.close();

    return recognizedText.text;
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String name = result.files.single.name;
      String path = result.files.single.path!;
      String extractedText = await extractText(path);
      print("Extracted Text: $extractedText");

      String text = extractedText.toLowerCase();
      String lowerName = name.toLowerCase();

      String category = "Others";
      String text = extractedText.toLowerCase();


// 💰 Payments (strong detection)
      if (text.contains("upi") ||
          text.contains("paid") ||
          text.contains("payment") ||
          text.contains("amount") ||
          text.contains("₹") ||
          text.contains("rs")) {
        category = "Payments";
      }

// 🧾 Bills
      else if (text.contains("invoice") ||
          text.contains("bill") ||
          text.contains("total")) {
        category = "Bills";
      }

// 🎓 Academic
      else if (text.contains("certificate") ||
          text.contains("marks") ||
          text.contains("result") ||
          text.contains("university")) {
        category = "Academic";
      }

// 🎟️ Tickets
      else if (text.contains("ticket") ||
          text.contains("boarding") ||
          text.contains("booking")) {
        category = "Tickets";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Document"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickFile,
              child: const Text("Pick File"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanDocument,
              child: const Text("Scan Document 📸"),
            ),
          ],
        ),
      ),
    );
  }
}