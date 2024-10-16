import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bab',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MateriScreen(),
    );
  }
}

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  _MateriScreenState createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  String searchQuery = ''; // Untuk menyimpan teks pencarian

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kembali'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 254, 253, 253),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                // Mengubah teks pencarian
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari Materi Pelajaran',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                _buildMaterialCard('Materi 1 - Biologi', '22 September', Icons.book),
                _buildMaterialCard('Materi 2', 'XX September', Icons.book),
                _buildMaterialCard('Materi 3', 'XX September', Icons.book),
                _buildMaterialCard('Video 1 - Biologi', 'XX September', Icons.videocam),
                _buildMaterialCard('Video 2', 'XX September', Icons.videocam),
                _buildMaterialCard('Video 3', 'XX Oktober', Icons.videocam),
                _buildMaterialCard('Kuis 1 - Biologi', 'XX September', Icons.quiz),
                _buildMaterialCard('Kuis 2', 'XX September', Icons.quiz),
                _buildMaterialCard('Kuis 3', 'XX September', Icons.quiz),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade100, // Warna latar belakang hijau muda
    );
  }

  Widget _buildMaterialCard(String title, String date, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      child: ListTile(
        leading: Icon(icon, size: 30),
        title: Text(title),
        subtitle: Text(date),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Tampilkan SnackBar ketika item ditekan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Anda memilih: $title')),
          );

          // Jika ingin navigasi ke halaman video, tambahkan logika navigasi di sini
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => VideoPage(title: title)),
          // );
        },
      ),
    );
  }
}
