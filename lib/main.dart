import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main(){
  runApp(const EvidenceLockerApp());
}
class EvidenceLockerApp extends StatelessWidget{
  const EvidenceLockerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evidence Locker',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5EDE4),
        primaryColor: const Color(0xFF2E2E2E),
        fontFamily: 'Roboto', // later we can change
      ),
      home: const HomeScreen(),
    );
  }
}