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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VideoPage(),
    );
  }
}

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Navigasi ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Vidio 1 - Biologi',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tanggal materi video
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                '22 September',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            
            // Navigasi Sebelumnya dan Selanjutnya
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Logika untuk "Sebelumnya"
                  },
                  child: const Text('Sebelumnya'),
                ),
                TextButton(
                  onPressed: () {
                    // Logika untuk "Selanjutnya"
                  },
                  child: const Text('Selanjutnya'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),

            // Placeholder untuk Gambar Video
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Gambar Video',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Instruksi Materi
            const Text(
              'Vidio 1 - Biologi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Memahami Vidio materi dibawah ini\n'
              '2. Ringkas Materi yang telah Dibaca\n'
              '3. Beri Pendapat dan Saran terhadap Materi Tersebut',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
