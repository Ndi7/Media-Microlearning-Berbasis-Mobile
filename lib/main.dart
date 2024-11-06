import 'package:flutter/material.dart';
import 'login_page.dart';
import 'siswa/home_page.dart';
import 'siswa/Kelas.dart';
import 'siswa/unit_page.dart';
import 'siswa/ubahnohp_page.dart';
import 'siswa/riwayat_nilai.dart';
import 'siswa/profil.dart';
import 'siswa/BabPage.dart';
import 'lupasandi_page.dart'; // Import the LupaSandiPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/lupa-sandi': (context) =>
            LupaSandiPage(), // Add route for LupaSandiPage
      },
    );
  }
}
