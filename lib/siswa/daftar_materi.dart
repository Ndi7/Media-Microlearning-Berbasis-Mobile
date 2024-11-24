import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
import '../guru/detail_materi.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemCount: widget.materiList.length,
          itemBuilder: (context, index) {
            final materi = widget.materiList[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MateriDetailPage(materi: materi)));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                child: Card(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        materi['judul'] ?? 'Judul tidak tersedia'),
                    subtitle: Text(
                      materi['deskripsi'] ?? 'Deskripsi tidak tersedia',
                      maxLines: 3,
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
