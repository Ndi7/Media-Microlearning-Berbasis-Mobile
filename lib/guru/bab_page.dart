import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
import 'package:media_learning_berbasis_mobile/siswa/home_page.dart';
import 'unit_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'material_model.dart';
import 'profil.dart';

Future<BabIndex> fetchBabIndex() async {
  final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/bab'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return BabIndex.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Gagal menampilkan bab Bab');
  }
}

class BabPage extends StatefulWidget {
  final String className;

  const BabPage({super.key, required this.className});

  @override
  _BabPageState createState() => _BabPageState();
}

class _BabPageState extends State<BabPage> {
  void _navigateToMateriScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MateriScreen(),
      ),
    );
  }

  void _showEditDialog(int babIndex) {
    TextEditingController controller =
        TextEditingController(text: 'Bab ${babIndex + 1}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Bab'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nama Bab',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement edit functionality here
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(int babIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Bab'),
          content:
              Text('Apakah Anda yakin ingin menghapus Bab ${babIndex + 1}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                // Implement delete functionality here
                Navigator.pop(context);
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  //fungsi kirim add data bab ke api database
  Future<void> addBab(String namaBab) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse('http://10.0.2.2:8000/api/bab');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'judul_bab': namaBab,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sukses menambah bab!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menambah bab!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat menambah bab!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  //baris kode untuk pop up tambah bab
  void _showAddBabDialog() {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Bab Baru'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Nama Bab',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                final String namaBab = controller.text.trim();
                if (namaBab.isNotEmpty) {
                  addBab(namaBab);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Nama bab tidak boleh kosong!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0),
          child: Text(
            widget.className,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        foregroundColor: Colors.black,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      backgroundColor: const Color(0xFF9BF6B5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Bab',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white70,
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
          ),
          // Add Bab Button
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton.icon(
              onPressed: _showAddBabDialog,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Bab'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: _navigateToMateriScreen,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            'Bab ${index + 1}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: PopupMenuButton<String>(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditDialog(index);
                              } else if (value == 'delete') {
                                _showDeleteConfirmation(index);
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Hapus'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
