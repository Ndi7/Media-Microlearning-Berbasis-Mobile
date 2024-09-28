import 'package:flutter/material.dart';

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

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(120,55),
        child: AppBar(
        title: const Text('Kembali'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi ketika tombol kembali ditekan
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
      backgroundColor: Colors.green.shade100, // Light green background
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
            // Aksi ketika tile ditekan
          },
        ),
      ),
    );
  }
}
