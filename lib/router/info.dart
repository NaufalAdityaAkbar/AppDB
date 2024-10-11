import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<dynamic> infoList = [];
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInfo();
  }

  Future<void> fetchInfo() async {
    final response =
        await http.get(Uri.parse('https://hayy.my.id/api-mulki/info.php'));
    if (response.statusCode == 200) {
      setState(() {
        infoList = json.decode(response.body);
      });
    } else {
      throw Exception('Gagal memuat data informasi');
    }
  }

  Future<void> addInfo() async {
    final response = await http.post(
      Uri.parse('https://hayy.my.id/api-mulki/info.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'judul_info': _judulController.text,
        'isi_info': _isiController.text,
        'tgl_post_info': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      fetchInfo();
      _judulController.clear();
      _isiController.clear();
    } else {
      throw Exception('Gagal menambahkan informasi');
    }
  }

  Future<void> editInfo(String id) async {
    final response = await http.put(
      Uri.parse('https://hayy.my.id/api-mulki/info.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'kd_info': id,
        'judul_info': _judulController.text,
        'isi_info': _isiController.text,
        'tgl_post_info': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      fetchInfo();
      _judulController.clear();
      _isiController.clear();
    } else {
      throw Exception('Gagal mengedit informasi');
    }
  }

  Future<void> deleteInfo(String id) async {
    final response = await http.delete(
      Uri.parse('https://hayy.my.id/api-mulki/info.php?kd_info=$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      fetchInfo();
    } else {
      throw Exception('Gagal menghapus informasi');
    }
  }

  void _showAddInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Informasi Baru'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _judulController,
                  decoration: InputDecoration(hintText: "Judul Informasi"),
                ),
                TextField(
                  controller: _isiController,
                  decoration: InputDecoration(hintText: "Isi Informasi"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tambah'),
              onPressed: () {
                addInfo();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditInfoDialog(String id, String judul, String isi) {
    _judulController.text = judul;
    _isiController.text = isi;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Informasi'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _judulController,
                  decoration: InputDecoration(hintText: "Judul Informasi"),
                ),
                TextField(
                  controller: _isiController,
                  decoration: InputDecoration(hintText: "Isi Informasi"),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Simpan'),
              onPressed: () {
                editInfo(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus informasi ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                deleteInfo(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Warna latar belakang hitam Spotify
      appBar: AppBar(
        title: Text('Informasi', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E1E1E), // Warna hitam yang tidak terlalu gelap
        elevation: 0,
      ),
      body: infoList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1DB954)))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: infoList.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color(0xFF181818), // Warna kartu gelap Spotify
                  elevation: 2,
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      infoList[index]['judul_info'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white, // Teks putih
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text(
                          'Diposting pada: ${infoList[index]['tgl_post_info']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400], // Teks abu-abu muda
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          infoList[index]['isi_info'],
                          style: TextStyle(
                              fontSize: 14, color: Colors.white), // Teks putih
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: Color(0xFF1DB954)), // Ikon hijau Spotify
                          onPressed: () {
                            _showEditInfoDialog(
                              infoList[index]['kd_info'],
                              infoList[index]['judul_info'],
                              infoList[index]['isi_info'],
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                infoList[index]['kd_info']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddInfoDialog,
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF1DB954), // Warna hijau Spotify
      ),
    );
  }
}
