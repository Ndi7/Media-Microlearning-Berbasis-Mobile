import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bab_page.dart';

// Fungsi untuk menambah bab
Future<void> addBab(
    BuildContext context, String namaBab, VoidCallback onSuccess) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;

  final url = Uri.parse('$apiUrl/bab');
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
      onSuccess();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sukses menambah bab!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menambah bab!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terjadi kesalahan saat menambah bab!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// Fungsi untuk menampilkan dialog tambah bab
void showAddBabDialog(BuildContext context, VoidCallback onSuccess) {
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
                addBab(context, namaBab, onSuccess);

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nama bab tidak boleh kosong!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      );
    },
  );
}

//Fungsi Fetch data dari Api Bab
Future getBab() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;

  if (token == null) {
    throw Exception('Token tidak ditemukan');
  }
  final url = Uri.parse('$apiUrl/bab');
  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $token',
  });
  if (response.statusCode == 200) {
    // Parsing JSON menjadi Map<String,   dynamic>
    final data = jsonDecode(response.body);
    return data['bab']; // Mengembalikan list bab
    // return jsonDecode(response.body);
  } else {
    throw Exception('Gagal mengambil data Bab');
  }
}

// Fungsi untuk melakukan request edit bab
Future<void> editBab(int id, String judulBab) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;

  if (token == null) {
    throw Exception('Token tidak ditemukan');
  }

  final url = Uri.parse('$apiUrl/$id');
  final response = await http.patch(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode({'judul_bab': judulBab}),
  );

  if (response.statusCode == 200) {
    print('Berhasil mengedit Bab');
  } else {
    print('Gagal mengedit Bab: ${response.statusCode}');
    throw Exception('Gagal mengedit data Bab');
  }
}

// Fungsi untuk melakukan request delete bab
Future<void> deleteBab(int id) async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  final apiUrl = dotenv.env['API_URL']!;

  if (token == null) {
    throw Exception('Token tidak ditemukan');
  }

  final url = Uri.parse('$apiUrl/$id');
  final response = await http.delete(
    url,
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    print('Berhasil menghapus Bab');
  } else {
    print('Gagal menghapus Bab: ${response.statusCode}');
    throw Exception('Gagal menghapus data Bab');
  }
}

class EditDialog {
  static void show(BuildContext context, int idBab, String judulBab,
      Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: judulBab);

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
              onPressed: () async {
                String editedText = controller.text;
                await editBab(idBab, editedText); // Panggil fungsi editBab
                onSave(editedText);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
