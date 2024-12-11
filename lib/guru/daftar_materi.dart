import 'dart:developer';

import 'package:flutter/material.dart';
import 'dashboard_kuis.dart';
import 'edit_materi.dart';
import 'home_page.dart';
import 'profil.dart';
import 'detail_materi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MateriScreen extends StatefulWidget {
  final List<dynamic> materiList;

  const MateriScreen({super.key, required this.materiList});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  late List<dynamic> materiList;
  void _onItemTapped(int index) {
    setState(() {});

    if (index == 0) {
      // Navigasi ke RiwayatNilaiPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePageGuru()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DashboardKuisScreens()),
      );
    } else if (index == 2) {
      // Navigasi ke ProfilPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    materiList = List.from(widget.materiList);
  }

  // Fungsi untuk menghapus materi
  Future<void> deleteMateri(int materiId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final apiUrl = dotenv.env['API_URL']!;

    final url = Uri.parse("$apiUrl/materi/$materiId");

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

          // Update list di widget induk jika perlu
          widget.materiList.removeWhere((materi) => materi['id'] == materiId);
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
        log("Token: $token");
        log("Response Status: ${response.statusCode}");
        log("Response Body: ${response.body}");
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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            unselectedLabelStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Colors.black,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_circle,
                  color: Colors.blue,
                ),
                label: 'Kuis',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                label: 'Profil',
              ),
            ],
            onTap: _onItemTapped,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView.builder(
          itemCount: widget.materiList.length,
          itemBuilder: (context, index) {
            final materi = widget.materiList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MateriDetailPage(materi: materi),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 6,
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                        materi['judul'] ?? 'Judul tidak tersedia'),
                    trailing: Wrap(
                      spacing: -16,
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

                              // Jika update berhasil, perbarui data di list
                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                setState(() {
                                  // Temukan index materi yang diupdate
                                  int index = materiList.indexWhere(
                                      (m) => m['id'] == result['id']);
                                  if (index != -1) {
                                    // Update materi di list dengan data baru
                                    materiList[index] = result;
                                  }
                                });
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
                                  title: const Text("Konfirmasi Hapus Materi"),
                                  content: const Text(
                                      "Apakah Anda yakin ingin menghapus materi ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Tutup dialog
                                        deleteMateri(
                                            materi['id']); // Hapus materi
                                      },
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
