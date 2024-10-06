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
              height: 120, // Tinggi kotak diperbesar
              child: KelasButton(
                text: 'Kelas 10',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelas 10 dipilih')),
                  );
                },
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: 120, // Tinggi kotak diperbesar
              child: KelasButton(
                text: 'Kelas 11',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelas 11 dipilih')),
                  );
                },
              ),
            ),
            const SizedBox(height: 17),
            SizedBox(
              height: 120, // Tinggi kotak diperbesar
              child: KelasButton(
                text: 'Kelas 12',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kelas 12 dipilih')),
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
        padding: EdgeInsets.zero, // Menghilangkan padding default
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Sudut yang lebih bulat
        ),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 102, 204, 255),
              Color.fromARGB(255, 102, 204, 255)
            ], // Gradasi kuning
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 251, 250, 250).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 4), // Posisi bayangan
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school,
                color: Color.fromARGB(255, 4, 4, 4),
              ),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 2, 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
