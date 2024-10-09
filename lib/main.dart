import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'Kelas.dart';
import 'unit_page.dart';
import 'ubahnohp_page.dart';
import 'riwayat_nilai.dart';
import 'profil.dart';
<<<<<<< HEAD
import 'bab_page.dart';
=======
import 'Tambah_Materi.dart';
>>>>>>> 59b8da1c20885cb393c7606bfdc3aa6d8934196a

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
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}
