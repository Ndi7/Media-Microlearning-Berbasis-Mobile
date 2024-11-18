import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'material_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';

class MateriDetailPage extends StatefulWidget {
  final Map<String, dynamic> materi;

  const MateriDetailPage({super.key, required this.materi});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  @override
  Widget build(BuildContext context) {
    final materi = widget.materi;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembali'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.book),
                  const SizedBox(width: 12),
                  Text(
                    materi['judul'] ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                materi['deskripsi'] ?? 'Deskripsi tidak tersedia',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              // Image.network(materi['file_path'])
            ],
          ),
        ),
      ),
    );
  }
}
