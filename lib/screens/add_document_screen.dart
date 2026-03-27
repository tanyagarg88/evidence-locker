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
      print("OCR TEXT: $extractedText");

      String text = extractedText.toLowerCase();
      String category = "Others";
      if (text.contains("upi") ||
          text.contains("₹") ||
          text.contains("paid") ||
          text.contains("amount")) {
        category = "Payments";
      }
      else if (text.contains("certificate") ||
          text.contains("course") ||
          text.contains("completion") ||
          text.contains("university")) {
        category = "Academic";
      }
      else if (text.contains("bill") ||
          text.contains("invoice")) {
        category = "Bills";
      }
      else if (text.contains("ticket") ||
          text.contains("booking")) {
        category = "Tickets";
      }
      else if (path.endsWith(".jpg") || path.endsWith(".png")) {
        category = "Images";
      }
      Navigator.pop(context, {
        "name": name,
        "path": path,
        "category": category,
      });
    } else {
      print("No image captured");
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
      String combined = text + lowerName;

      String category = "Others";

// 📸 Screenshots (FIRST PRIORITY)
      if (combined.contains("screenshot")) {
        category = "Screenshots";
      }

// 💰 Payments
      else if (combined.contains("upi") ||
          combined.contains("paid") ||
          combined.contains("payment") ||
          combined.contains("₹") ||
          combined.contains("rs") ||
          combined.contains("amount")) {
        category = "Payments";
      }

// 🧾 Bills
      else if (combined.contains("invoice") ||
          combined.contains("bill") ||
          combined.contains("total")) {
        category = "Bills";
      }

// 🎓 Academic (IMPROVED)
      else if (combined.contains("certificate") ||
          combined.contains("course") ||
          combined.contains("completion") ||
          combined.contains("university") ||
          combined.contains("marks") ||
          combined.contains("result") ||
          combined.contains("student")) {
        category = "Academic";
      }

// 🎟️ Tickets
      else if (combined.contains("ticket") ||
          combined.contains("booking") ||
          combined.contains("boarding")) {
        category = "Tickets";
      }

// 🖼️ Images
      else if (lowerName.endsWith(".jpg") ||
          lowerName.endsWith(".png")) {
        category = "Images";
      }
      Navigator.pop(context, {
        "name": name,
        "path": path,
        "category": category,
      });

    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EDE4),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
        title: const Text(
          "Add Document",
          style: TextStyle(
            color: Color(0xFF6F4E37),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(height: 20),

            const Text(
              "Upload your document 📂",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E2E2E),
              ),
            ),

            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.brown.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.brown.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.folder,
                      size: 50,
                      color: Color(0xFF916241),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Upload from device",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Choose files from storage",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: pickFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF916241),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Upload"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // OR TEXT
            const Text(
              "OR",
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: scanDocument,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.brown.withOpacity(0.08),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt,
                        color: Color(0xFF916241), size: 28),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Text(
                        "Scan Document",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}