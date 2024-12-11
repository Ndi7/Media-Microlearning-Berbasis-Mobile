import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:media_learning_berbasis_mobile/guru/dashboard_kuis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'materi_model.dart';

class AddKuisScreens extends StatefulWidget {
  const AddKuisScreens({super.key});

  @override
  State<AddKuisScreens> createState() => AddKuisScreensState();
}

Future<List<Materi>> fetchMateri() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;
  if (token == null) {
    throw Exception('Token tidak ditemukan');
  }
  final url = Uri.parse('$apiUrl/materi');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
  });
  if (response.statusCode == 200) {
    final parsed = json.decode(response.body); // Decode JSON
    // Ambil key `materi` yang berisi list
    if (parsed['materi'] is List) {
      return (parsed['materi'] as List)
          .map((json) => Materi.fromJson(json))
          .toList();
    } else {
      throw Exception("Format respons API tidak valid");
    }
  } else {
    throw Exception('Gagal mengambil Materi');
  }
}

class AddKuisScreensState extends State<AddKuisScreens> {
  Materi? _selectedMateri; // Untuk menyimpan materi yang dipilih
  List<Materi> _materiList = []; // Daftar materi
  bool _isLoading = true;
  final TextEditingController _durasiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAndSetMateri();
  }

  // Fungsi untuk mengambil materi dari API
  Future<void> _fetchAndSetMateri() async {
    try {
      List<Materi> materiList = await fetchMateri();
      setState(() {
        _materiList = materiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog("Terjadi kesalahan: $e");
    }
  }

  // Fungsi untuk menambah kuis
  Future<void> addKuis(Materi selectedMateri, String durasi) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final apiUrl = dotenv.env['API_URL']!;
    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse('$apiUrl/kuis');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'judul_kuis': selectedMateri.judul, // Kirim judul materi
        'materi_id': selectedMateri.id, // Kirim ID materi
        'durasi': durasi,
      }),
    );

    log("Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log("Kuis berhasil ditambahkan: ${data['message']}");
      _showSuccessDialog(data['message']);
    } else {
      // Parsing error jika ada
      try {
        final error = json.decode(response.body);
        _showErrorDialog("Gagal menambahkan kuis: ${error['message']}");
      } catch (e) {
        log("Parsing error failed: $e");
        _showErrorDialog("Gagal menambahkan kuis. Response: ${response.body}");
      }
    }
  }

  // Menampilkan dialog sukses
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Berhasil"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardKuisScreens()),
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Menampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan tampilan UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Kuis"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Pilih Materi untuk Kuis:",
                      style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 10),
                  _dropDown(),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _durasiController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Masukkan durasi, contoh: 00:10:00",
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  const SizedBox(height: 20),
                  _butonTambah(context),
                ],
              ),
            ),
    );
  }

  // Fungsi untuk membuat tombol "Buat"
  ElevatedButton _butonTambah(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_selectedMateri != null && _durasiController.text.isNotEmpty) {
          try {
            await addKuis(_selectedMateri!, _durasiController.text);
          } catch (e) {
            log("Error: $e");
            _showErrorDialog("Terjadi kesalahan: $e");
          }
        } else {
          _showErrorDialog("Pilih materi dan masukkan durasi terlebih dahulu!");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        elevation: 5,
      ),
      child: const Text(
        "Buat",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // Dropdown untuk memilih materi
  DropdownButton<Materi> _dropDown() {
    return DropdownButton<Materi>(
      value: _selectedMateri,
      isExpanded: true,
      hint: const Text("Pilih materi"),
      items: _materiList.map((materi) {
        return DropdownMenuItem<Materi>(
          value: materi,
          child: Text(materi.judul),
        );
      }).toList(),
      onChanged: (Materi? newValue) {
        setState(() {
          _selectedMateri = newValue;
        });
        if (newValue != null) {
          log("Materi yang dipilih: ${newValue.judul}");
        }
      },
    );
  }
}
