import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GaleryScreen extends StatefulWidget {
  @override
  _GaleryScreenState createState() => _GaleryScreenState();
}

class _GaleryScreenState extends State<GaleryScreen> {
  Future<List<dynamic>> fetchGalery() async {
    final response = await http.get(Uri.parse('https://hayy.my.id/api-mulki/galery.php'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load galery data');
    }
  }

  Future<void> addGalery(String judul, String isi, String imageUrl, String status, String kdPetugas) async {
    final response = await http.post(
      Uri.parse('https://hayy.my.id/api-mulki/galery.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'judul_galery': judul,
        'isi_galery': isi,
        'image_url': imageUrl,
        'tgl_post_galery': DateTime.now().toIso8601String(),
        'status_galery': status,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {}); // Refresh UI on successful addition
    } else {
      throw Exception('Failed to add galery');
    }
  }

  Future<void> editGalery(String id, String judul, String isi, String imageUrl, String status, String kdPetugas) async {
    final response = await http.put(
      Uri.parse('https://hayy.my.id/api-mulki/galery.php'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'kd_galery': id,
        'judul_galery': judul,
        'isi_galery': isi,
        'image_url': imageUrl,
        'tgl_post_galery': DateTime.now().toIso8601String(),
        'status_galery': status,
        'kd_petugas': kdPetugas,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {}); // Refresh UI on successful update
    } else {
      throw Exception('Failed to edit galery');
    }
  }

  Future<void> deleteGalery(String id) async {
    final response = await http.delete(
      Uri.parse('https://hayy.my.id/api-mulki/galery.php?kd_galery=$id'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      setState(() {}); // Refresh UI on successful deletion
    } else {
      throw Exception('Failed to delete galery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Galeri', style: TextStyle(color: Colors.white)),
         backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchGalery(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var data = snapshot.data![index];
              return GestureDetector(
                onTap: () => _showDetailsOverlay(context, data),
                child: Card(
                  color: Colors.grey[900],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(data['image_url'] ?? 'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data['judul_galery'] ?? 'No Title',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDetailsOverlay(BuildContext context, dynamic data) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // 60% transparan
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900]!.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    data['image_url'] ?? 'https://creazilla-store.fra1.digitaloceanspaces.com/icons/3251108/person-icon-md.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['judul_galery'] ?? 'No Title',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(data['isi_galery'] ?? 'No Description', style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text(data['tgl_post_galery'] ?? 'No Date', style: TextStyle(color: Colors.grey)),
                      Text(data['status_galery'] ?? 'No Status', style: TextStyle(color: Colors.grey)),
                      Text(data['kd_petugas'] ?? 'No Kode Petugas', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                ButtonBar(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Close', style: TextStyle(color: Colors.green)),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEditDialog(context, data);
                      },
                      child: Text('Edit', style: TextStyle(color: Colors.green)),
                    ),
                    TextButton(
                      onPressed: () async {
                        try {
                          await deleteGalery(data['kd_galery']);
                          Navigator.of(context).pop();
                        } catch (e) {
                          _showErrorDialog(context, 'Failed to delete galery: $e');
                        }
                      },
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    final _judulController = TextEditingController();
    final _isiController = TextEditingController();
    final _imageUrlController = TextEditingController();
    final _statusController = TextEditingController();
    final _kdPetugasController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Galery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: _isiController,
                decoration: InputDecoration(labelText: 'Isi'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _kdPetugasController,
                decoration: InputDecoration(labelText: 'Kode Petugas'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await addGalery(
                  _judulController.text,
                  _isiController.text,
                  _imageUrlController.text,
                  _statusController.text,
                  _kdPetugasController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, dynamic data) {
    final _judulController = TextEditingController(text: data['judul_galery']);
    final _isiController = TextEditingController(text: data['isi_galery']);
    final _imageUrlController = TextEditingController(text: data['image_url']);
    final _statusController = TextEditingController(text: data['status_galery']);
    final _kdPetugasController = TextEditingController(text: data['kd_petugas']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Galery'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _judulController,
                decoration: InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: _isiController,
                decoration: InputDecoration(labelText: 'Isi'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: _kdPetugasController,
                decoration: InputDecoration(labelText: 'Kode Petugas'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await editGalery(
                  data['kd_galery'],
                  _judulController.text,
                  _isiController.text,
                  _imageUrlController.text,
                  _statusController.text,
                  _kdPetugasController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}