import 'package:flutter/material.dart';
import 'login.dart'; // Import your login screen

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // App logo or icon
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white,
              child: Icon(Icons.sports_basketball, size: 100, color: Color(0xFFE91E63)),
            ),
            SizedBox(height: 50),
            // App name or welcome message
            Text(
              'Welcome to MyApp!',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            // Button to start the app and navigate to login
            ElevatedButton(
              onPressed: () {
                // Navigate to LoginScreen when pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                iconColor: Colors.black, // Black button
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
