import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class AddDocumentScreen extends StatefulWidget {
  const AddDocumentScreen({super.key});

  @override
  State<AddDocumentScreen> createState() => _AddDocumentScreenState();
}

class _AddDocumentScreenState extends State<AddDocumentScreen> {

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
      if (lowerName.contains("screenshot")) {
        category = "Screenshots";
      }
      else if (lowerName.contains("img") ||
          lowerName.contains("photo") ||
          lowerName.endsWith(".jpg") ||
          lowerName.endsWith(".png")) {
        category = "Images";
      }
      else if (text.contains("upi") ||
          text.contains("paid") ||
          text.contains("₹") ||
          lowerName.contains("receipt")) {
        category = "Payments";
      }
      else if (text.contains("invoice") ||
          text.contains("bill")) {
        category = "Bills";
      }
      else if (text.contains("certificate") ||
          text.contains("result")) {
        category = "Academic";
      }
      else if (lowerName.contains("aadhaar") ||
          lowerName.contains("pan") ||
          lowerName.contains("id")) {
        category = "IDs";
      }
      else if (text.contains("ticket") ||
          text.contains("booking")) {
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