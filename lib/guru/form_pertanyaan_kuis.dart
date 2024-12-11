import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AddPertanyaanScreens extends StatefulWidget {
  final int kuisId;
  const AddPertanyaanScreens({super.key, required this.kuisId});

  @override
  State<AddPertanyaanScreens> createState() => _AddPertanyaanScreensState();
}

class _AddPertanyaanScreensState extends State<AddPertanyaanScreens> {
  final TextEditingController _pertanyaanController = TextEditingController();
  final TextEditingController _jawabanBenarController = TextEditingController();

  final List<TextEditingController> _pilihanControllers =
      List.generate(5, (index) => TextEditingController());

  @override
  void dispose() {
    _pertanyaanController.dispose();
    _jawabanBenarController.dispose();
    for (var controller in _pilihanControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _submitPertanyaan() async {
    final pertanyaan = _pertanyaanController.text.trim();
    final jawabanBenar = _jawabanBenarController.text.trim().toUpperCase();
    final pilihanJawaban =
        _pilihanControllers.map((c) => c.text.trim()).toList();

    if (pertanyaan.isEmpty ||
        jawabanBenar.isEmpty ||
        pilihanJawaban.contains('')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi!')),
      );
      return;
    }

    try {
      await postPertanyaanKuis(
        kuisId: widget.kuisId.toString(),
        pertanyaan: pertanyaan,
        jawabanA: pilihanJawaban[0],
        jawabanB: pilihanJawaban[1],
        jawabanC: pilihanJawaban[2],
        jawabanD: pilihanJawaban[3],
        jawabanE: pilihanJawaban[4],
        kunciJawaban: jawabanBenar,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pertanyaan berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );
      // Reset fields after successful submission
      _pertanyaanController.clear();
      _jawabanBenarController.clear();
      for (var controller in _pilihanControllers) {
        controller.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambahkan pertanyaan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis Dashboard'),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _pertanyaanController,
              decoration: const InputDecoration(
                hintText: 'Pertanyaan',
              ),
            ),
            const SizedBox(height: 16.0),
            _InputForm(_pilihanControllers),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _jawabanBenarController,
              decoration: const InputDecoration(
                hintText: 'Jawaban Benar (A-E)',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color(0xff007BFF),
                ),
              ),
              onPressed: _submitPertanyaan,
              child: const Text(
                'Tambah',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputForm extends StatelessWidget {
  final List<TextEditingController> controllers;

  const _InputForm(this.controllers, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(controllers.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: TextFormField(
            controller: controllers[index],
            decoration: InputDecoration(
              labelText: 'Pilihan ${index + 1}',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

Future<void> postPertanyaanKuis({
  required String kuisId,
  required String pertanyaan,
  required String jawabanA,
  required String jawabanB,
  required String jawabanC,
  required String jawabanD,
  required String jawabanE,
  required String kunciJawaban,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;
  final url = "$apiUrl/pertanyaan-kuis";
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "kuis_id": kuisId,
        "pertanyaan": pertanyaan,
        "jawaban_a": jawabanA,
        "jawaban_b": jawabanB,
        "jawaban_c": jawabanC,
        "jawaban_d": jawabanD,
        "jawaban_e": jawabanE,
        "kunci_jawaban": kunciJawaban,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      log("Success: ${data['message']}");
      log("Data: ${data['data']}");
    } else {
      log("Error: ${response.statusCode}");
      log("Body: ${response.body}");
    }
  } catch (e) {
    log("Exception: $e");
  }
}
