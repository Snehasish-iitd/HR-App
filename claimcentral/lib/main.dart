import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(HRManagementApp());
}

class HRManagementApp extends StatelessWidget {
  const HRManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HR Management System',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 5, 17, 89), // Replace with your theme color
        hintColor: Color(0xFF654321),  // Replace with your theme color
        scaffoldBackgroundColor: const Color.fromARGB(255, 31, 124, 164),
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
