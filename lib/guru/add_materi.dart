import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'daftar_materi.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class MaterialFormPage extends StatefulWidget {
  const MaterialFormPage({super.key});

  @override
  MaterialFormPageState createState() => MaterialFormPageState();
}

class MaterialFormPageState extends State<MaterialFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedFile;
  List<Map<String, dynamic>> chapters = [];
  int? selectedChapterId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChapters();
  }

  // Fungsi untuk mengambil data bab dari API
  Future<void> fetchChapters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final apiUrl = dotenv.env['API_URL']!;

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/bab'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('bab')) {
          final List<dynamic> data = responseData['bab'];
          setState(() {
            chapters = data.map((item) {
              return {
                'bab_id': item['id'],
                'judul': item['judul_bab'], // Menggunakan 'judul_bab' dari API
              };
            }).toList();
            // Sorting berdasarkan nomor bab
            chapters.sort((a, b) {
              RegExp regex = RegExp(r'Bab (\d+)');
              int? numA =
                  int.tryParse(regex.firstMatch(a['judul'])?.group(1) ?? '0');
              int? numB =
                  int.tryParse(regex.firstMatch(b['judul'])?.group(1) ?? '0');
              return (numA ?? 0).compareTo(numB ?? 0);
            });
            selectedChapterId = null;
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {}
  }

  Future<void> postMateri(BuildContext context) async {
    if (selectedChapterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silahkan pilih bab terlebih dahulu!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final apiUrl = dotenv.env['API_URL']!;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final url = Uri.parse('$apiUrl/materi');
    try {
      final request = http.MultipartRequest('POST', url)
        ..headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        })
        ..fields['judul'] = title
        ..fields['deskripsi'] = description
        ..fields['bab_id'] = selectedChapterId.toString();

      if (_selectedFile != null) {
        request.files.add(
            await http.MultipartFile.fromPath('file', _selectedFile!.path));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Materi berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        // await Future.delayed(const Duration(seconds: 1));

        _titleController.clear(); // Kosongkan judul
        _descriptionController.clear(); // Kosongkan deskripsi
        setState(() {
          _selectedFile = null;
          selectedChapterId = null;
        });
        fetchChapters();
        // _navigateToMateriScreen();
        setState(() {});
      } else {
        // print("Gagal menyimpan materi. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      // print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Kembali'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter Dropdown
                  const Text(
                    'Pilih Bab',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButton<int>(
                            value: selectedChapterId,
                            isExpanded: true,
                            hint: const Text("Pilih Bab"),
                            items: chapters.map((chapter) {
                              return DropdownMenuItem<int>(
                                value:
                                    chapter['bab_id'], // Menggunakan 'bab_id'
                                child: Text(
                                    chapter['judul']), // Menggunakan 'judul'
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                selectedChapterId = value;
                              });
                            },
                            underline: Container(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Title Field
                  const Text(
                    'Judul Materi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Judul Materi',
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description Field
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Deskripsi Materi (opsional)',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),

                  // Attachments Section
                  const Text(
                    'Lampirkan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text('Pilih File'),
                  ),
                  if (_selectedFile != null) ...[
                    const SizedBox(height: 10),
                    Text(
                        'File yang dipilih: ${_selectedFile!.path.split('/').last}')
                  ],

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          // Save Button
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  postMateri(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
