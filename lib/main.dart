import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_page.dart';
import 'siswa/home_page.dart';
import 'siswa/kelas_screen.dart';
import 'siswa/ubahnohp_page.dart';
import 'siswa/riwayat_nilai.dart';
import 'siswa/profil.dart';
import 'siswa/bab_page.dart';
import 'lupasandi_page.dart'; // Import the LupaSandiPage
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await dotenv.load(fileName: ".env");
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
        textTheme: GoogleFonts.lexendTextTheme(),
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
