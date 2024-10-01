import 'package:flutter/material.dart';

class DetailPenilaian extends StatelessWidget {
  final int quizNumber;

  const DetailPenilaian({super.key, required this.quizNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Kuis $quizNumber'),
      ),
      body: Center(
        child: Text('Ini adalah halaman detail untuk Kuis $quizNumber'),
      ),
    );
  }
}
//NOT FINAL PAGE YET