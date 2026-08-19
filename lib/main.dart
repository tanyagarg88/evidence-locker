import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('documentsBox');
  runApp(const EvidenceLockerApp());
}

class EvidenceLockerApp extends StatelessWidget {
  const EvidenceLockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DocuVault AI',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5EDE4),
        primaryColor: const Color(0xFF2E2E2E),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}