import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/edit_materi.dart';
import 'Guru_Tambah_Materi.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
import 'add_materi.dart';
import 'detail_materi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MateriScreen extends StatefulWidget {
  final List<dynamic> materiList;

  const MateriScreen({super.key, required this.materiList});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  late List<dynamic> materiList;

  @override
  void initState() {
    super.initState();
    materiList = List.from(widget.materiList); // Buat salinan list
  }

  // Fungsi untuk menghapus materi
  Future<void> deleteMateri(int materiId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final url = Uri.parse("http://10.0.2.2:8000/api/materi/$materiId");

    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Hapus materi dari list lokal
        setState(() {
          materiList.removeWhere((materi) => materi['id'] == materiId);
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Materi berhasil dihapus!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus materi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Materi'),
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      backgroundColor: const Color(0xFF9BF6B5),
      body: ListView.builder(
        itemCount: widget.materiList.length,
        itemBuilder: (context, index) {
          final materi = widget.materiList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MateriDetailPage(materi: materi)));
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                title: Text(
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    materi['judul'] ?? 'Judul tidak tersedia'),
                trailing: Wrap(
                  spacing: -10,
                  children: [
                    IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditMateriFormPage(materi: materi),
                            ),
                          );

                          // Jika update berhasil, perbarui data di layar
                          if (result == true) {
                            // Fetch ulang data dari server atau perbarui item di list
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data materi diperbarui!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Lakukan tindakan refresh atau fetch ulang data
                          }
                        }),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Hapus Materi"),
                              content: const Text(
                                  "Apakah Anda yakin ingin menghapus materi ini?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Batal"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Tampilkan dialog konfirmasi sebelum menghapus
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Konfirmasi'),
                                          content: const Text(
                                            'Apakah Anda yakin ingin menghapus materi ini?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Tutup dialog
                                              },
                                              child: const Text('Batal'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context); // Tutup dialog
                                                deleteMateri(materi[
                                                    'id']); // Hapus materi
                                              },
                                              child: const Text(
                                                'Hapus',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text("Hapus"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                subtitle: Text(
                  materi['deskripsi'] ?? 'Deskripsi tidak tersedia',
                  maxLines: 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
