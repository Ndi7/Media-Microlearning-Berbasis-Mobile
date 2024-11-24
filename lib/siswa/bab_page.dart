import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
// import 'package:media_learning_berbasis_mobile/siswa/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'daftar_materi.dart';
import 'profil.dart';
import '../guru/bab_function.dart';

class BabPageSiswa extends StatefulWidget {
  const BabPageSiswa({
    super.key,
  });
  @override
  BabPageState createState() => BabPageState();
}

class BabPageState extends State<BabPageSiswa> {
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
          title: const Padding(
            padding: EdgeInsets.only(),
            child: Text(
              'Biologi Kelas 12',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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
          const SizedBox(
            width: 15,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        bab['judul_bab'] ??
                                            'Bab tidak tersedia',
                                        style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
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
