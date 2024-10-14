import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KelasPage(),
    );
  }
}

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  _KelasPageState createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 118, 251, 153),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Kembali'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: KelasButton(
                text: 'Biologi Kelas 10',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biologi Kelas 10 dipilih')),
                  );
                },
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: 120,
              child: KelasButton(
                text: 'Biologi Kelas 11',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biologi Kelas 11 dipilih')),
                  );
                },
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: 120,
              child: KelasButton(
                text: 'Biologi Kelas 12',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Biologi Kelas 12 dipilih')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KelasButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const KelasButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.white, // Background putih seperti pada gambar
        shadowColor: Colors.grey.withOpacity(0.5), // Bayangan lembut
        elevation: 3, // Efek bayangan
      ),
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Warna teks hitam
          ),
        ),
      ),
    );
  }
}
