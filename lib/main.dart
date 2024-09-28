import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'unit_page.dart';
import 'ubahnohp_page.dart';
import 'riwayat_nilai.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        '/home': (context) => HomePage(),
      },
    );
  }
}
