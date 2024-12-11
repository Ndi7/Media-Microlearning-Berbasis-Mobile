import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:media_learning_berbasis_mobile/guru/form_add_kuis.dart';
import 'package:media_learning_berbasis_mobile/guru/form_pertanyaan_kuis.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardKuisScreens extends StatefulWidget {
  const DashboardKuisScreens({super.key});

  @override
  State<DashboardKuisScreens> createState() => _DashboardKuisScreensState();
}

class _DashboardKuisScreensState extends State<DashboardKuisScreens> {
  List kuisList = [];
  @override
  void initState() {
    super.initState();
    _fetchKuisList();
  }

  Future<void> _fetchKuisList() async {
    try {
      var data = await getKuis();
      setState(() {
        kuisList = data['kuis'];
      });
    } catch (e) {
      log('Error: $e');
    }
  }

  //fungsi hapus kuis
  Future<void> deleteKuis(int kuisId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final apiUrl = dotenv.env['API_URL']!;

    final url = Uri.parse("$apiUrl/kuis/$kuisId");

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
          kuisList.removeWhere((kuis) => kuis['id'] == kuisId);

          // Update list di widget induk jika perlu
          kuisList.removeWhere((kuis) => kuis['id'] == kuisId);
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
            content: Text('Gagal menghapus kuis'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AddKuisScreens()));
        },
        backgroundColor: const Color(0xff000000),
        child: const Icon(
          Icons.add,
          color: Color(0xffF5FF44),
        ),
      ),
      backgroundColor: const Color(0xFF9BF6B5),
      appBar: AppBar(
        title: const Text('Dashboard Kuis'),
        toolbarHeight: 70,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder(
              future: getKuis(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.hasData) {
                  List kuisList = snapshot.data as List;
                  //logika sorting disini

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(kuisList.length, (index) {
                      final kuis = kuisList[index];
                      return GestureDetector(
                        onTap: () {
                          final kuisId = kuis['id'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddPertanyaanScreens(kuisId: kuisId),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(
                              Icons.quiz_outlined,
                              color: Colors.orange[700],
                            ),
                            title: Text(
                              'Kuis ${kuis['judul_kuis']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: const Color(0xff030303).withOpacity(1),
                                  height: 1.3,
                                ),
                                children: [
                                  const TextSpan(text: 'Dibuat oleh '),
                                  TextSpan(
                                    text: kuis['created_by'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const TextSpan(text: '\nDurasi : '),
                                  TextSpan(
                                    text: kuis['durasi'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // isThreeLine: true,
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.delete_forever_outlined,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Konfirmasi Hapus Materi"),
                                      content: const Text(
                                          "Apakah Anda yakin ingin menghapus Kuis ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Batal"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context); // Tutup dialog
                                            deleteKuis(
                                                kuis['id']); // Hapus materi
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
                          ),
                        ),
                      );
                    }),
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              }),
        ),
      ),
    );
  }
}

//fetch data kuis dari api
Future getKuis() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;

  if (token == null) {
    throw Exception('Token tidak ditemukan');
  }
  final url = Uri.parse('$apiUrl/kuis');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
  });
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['kuis'];
  } else {
    throw Exception('Gagal mengambil data Kuis');
  }
}
