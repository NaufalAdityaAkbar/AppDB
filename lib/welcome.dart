import 'package:flutter/material.dart';
import 'home/home.dart';
import 'router/info.dart';
import 'router/agenda.dart';
import 'router/galery.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    InfoScreen(),
    AgendaScreen(),
    GaleryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 254, 12, 12),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Info',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Agenda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Galery',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white, // Warna item yang dipilih tetap putih
          unselectedItemColor: Colors.white.withOpacity(0.5), // Warna item yang tidak dipilih menjadi putih transparan
          onTap: _onItemTapped,
          backgroundColor: const Color.fromARGB(202, 0, 0, 0), // Latar belakang BottomNavigationBar transparan
          type: BottomNavigationBarType.fixed, // Tipe fixed agar semua item terlihat
        ),
      ),
    );
  }
}
