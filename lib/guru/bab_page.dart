import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'add_materi.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'materi_model.dart';
import 'daftar_materi.dart';
import 'profil.dart';
import 'bab_function.dart';

class BabPage extends StatefulWidget {
  // final String className;

  const BabPage({
    super.key,
  });
  @override
  BabPageState createState() => BabPageState();
}

class BabPageState extends State<BabPage> {
  void _showDeleteConfirmation(
      BuildContext context, int idBab, int index, Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Bab'),
          content: const Text('Apakah Anda yakin ingin menghapus bab ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(
                    context); // Tutup dialog sebelum melakukan penghapusan

                try {
                  await deleteBab(idBab); // Tunggu hingga penghapusan selesai
                  onDelete(
                      index); // Panggil callback setelah penghapusan berhasil
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menghapus Bab')),
                  );
                  print('Error: $e');
                }
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  List babList = [];

  @override
  void initState() {
    super.initState();
    _fetchBabList();
  }

  Future<void> _fetchBabList() async {
    try {
      var data = await getBab();
      setState(() {
        babList = data['bab'];
      });
    } catch (e) {
      // print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text(
            'Biologi Kelas 12',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 70,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
        ),
        backgroundColor: const Color(0xFF9BF6B5),
        body: SingleChildScrollView(
            child: Column(children: [
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 165,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showAddBabDialog(context, () {
                      setState(() {
                        getBab();
                      });
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    ' Bab',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    // minimumSize: const Size(double.infinity, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              SizedBox(
                width: 165,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MaterialFormPage()));
                  },
                  icon: const Icon(Icons.add),
                  label: const Text(
                    ' Materi',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          //Card Bab Start
          SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  future: getBab(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (snapshot.hasData) {
                      // print(snapshot.data);
                      List babList = snapshot.data as List;
                      // Sorting berdasarkan nomor bab
                      babList.sort((a, b) {
                        // Ekstrak nomor dari judul bab (contoh: "Bab 1" -> 1)
                        int numA = int.tryParse(RegExp(r'\d+')
                                    .firstMatch(a['judul_bab'])
                                    ?.group(0) ??
                                '0') ??
                            0;
                        int numB = int.tryParse(RegExp(r'\d+')
                                    .firstMatch(b['judul_bab'])
                                    ?.group(0) ??
                                '0') ??
                            0;
                        return numA.compareTo(numB);
                      });
                      return Wrap(
                        children: List.generate(babList.length, (index) {
                          final bab = babList[index];
                          return SizedBox(
                              width: 173, // Atur lebar sesuai kebutuhan
                              height: 185, // Atur tinggi sesuai kebutuhan
                              child: GestureDetector(
                                onTap: () {
                                  final materiList = bab['materi'] ?? [];
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MateriScreen(materiList: materiList),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //titik tiga
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          PopupMenuButton<String>(
                                            icon: const Icon(Icons.more_vert),
                                            onSelected: (value) {
                                              if (value == 'edit') {
                                                int idBab =
                                                    babList[index]['id'];
                                                String judulBab =
                                                    babList[index]['judul_bab'];
                                                EditDialog.show(
                                                  context,
                                                  idBab,
                                                  judulBab,
                                                  (editedText) {
                                                    setState(() {
                                                      // Update judul bab di data lokal setelah edit
                                                      babList[index]
                                                              ['judul_bab'] =
                                                          editedText;
                                                    });
                                                  },
                                                );
                                              } else if (value == 'delete') {
                                                int idBab =
                                                    babList[index]['id'];
                                                _showDeleteConfirmation(
                                                    context, idBab, index,
                                                    (int index) {
                                                  setState(() {
                                                    babList.removeAt(index);
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: const Text(
                                                            'Berhasil menghapus Bab'),
                                                        backgroundColor:
                                                            Colors.blue[600]),
                                                  );
                                                });
                                              }
                                            },
                                            itemBuilder:
                                                (BuildContext context) => [
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.blue),
                                                    SizedBox(width: 8),
                                                    Text('Edit'),
                                                  ],
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.delete,
                                                        color: Colors.red),
                                                    SizedBox(width: 8),
                                                    Text('Hapus'),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 25.0),
                                        child: Text(
                                          bab['judul_bab'] ??
                                              'Bab tidak tersedia',
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        }),
                      );
                    } else {
                      return const Center(child: Text('No data available'));
                    }
                  },
                ),
              ],
            ),
          )
        ])));
  }
}
