import 'package:flutter/material.dart';
import 'start.dart'; // Import the new start screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: StartScreen(), // Set StartScreen as the initial route
    );
  }
}
