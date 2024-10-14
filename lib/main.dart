import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'Kelas.dart';
import 'unit_page.dart';
import 'ubahnohp_page.dart';
import 'riwayat_nilai.dart';
import 'profil.dart';
import 'BabPage.dart';


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
