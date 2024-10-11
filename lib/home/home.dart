import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> galleryData = [];
  int currentImageIndex = 0;
  Timer? imageTimer;

  @override
  void initState() {
    super.initState();
    fetchGalleryData();
  }

  @override
  void dispose() {
    imageTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchGalleryData() async {
    final response = await http.get(Uri.parse('https://hayy.my.id/api-mulki/galery.php'));
    if (response.statusCode == 200) {
      setState(() {
        galleryData = json.decode(response.body);
      });
      startImageTimer();
    }
  }

  void startImageTimer() {
    imageTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        currentImageIndex = (currentImageIndex + 1) % galleryData.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[900], // Warna hitam yang lebih terang
        elevation: 0, // Menghilangkan bayangan
        title: Text(
          'Selamat Datang',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Tambahkan fungsi untuk notifikasi di sini
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(  // Tambahkan ini
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Galeri
              if (galleryData.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[800]!, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        galleryData[currentImageIndex]['image_url'],
                        fit: BoxFit.cover,
                        height: 200, // Tambahkan baris ini
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 16), // Tambahkan sedikit jarak setelah galeri
              // Kategori
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Daftar kategori
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: [
                    _buildCategoryItem('Agenda', Icons.event),
                    _buildCategoryItem('Informasi', Icons.info),
                    _buildCategoryItem('Berita', Icons.article),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Daftar agenda dan informasi
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildListItem('Agenda Terbaru', 'Detail agenda terbaru', Icons.event),
                    _buildListItem('Informasi Penting', 'Detail informasi penting', Icons.info),
                    _buildListItem('Berita Terkini', 'Detail berita terkini', Icons.article),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar telah dihapus
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 40),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String subtitle, IconData icon) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[800],
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.more_vert, color: Colors.grey),
    );
  }
}
