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
      appBar: PreferredSize(
        preferredSize: const Size(120, 55),
        child: AppBar(
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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
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
                  borderRadius: BorderRadius.circular(1),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                MateriTile(
                  icon: Icons.book,
                  title: 'Materi 1 - Biologi',
                  subtitle: '22 September',
                ),
                MateriTile(
                  icon: Icons.book,
                  title: 'Materi 2',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.book,
                  title: 'Materi 3',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.videocam,
                  title: 'Video 1 - Biologi',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.videocam,
                  title: 'Video 2',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.videocam,
                  title: 'Video 3',
                  subtitle: 'XX Oktober',
                ),
                MateriTile(
                  icon: Icons.quiz,
                  title: 'Kuis 1 - Biologi',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.quiz,
                  title: 'Kuis 2',
                  subtitle: 'XX September',
                ),
                MateriTile(
                  icon: Icons.quiz,
                  title: 'Kuis 3',
                  subtitle: 'XX September',
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade100, // Warna latar belakang hijau muda
    );
  }
}

class MateriTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const MateriTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Card(
        child: ListTile(
          leading: Icon(icon, size: 30),
          title: Text(title),
          subtitle: Text(subtitle),
          onTap: () {
            // Tampilkan SnackBar ketika item ditekan
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(title)),
            );
          },
        ),
      ),
    );
  }
}
