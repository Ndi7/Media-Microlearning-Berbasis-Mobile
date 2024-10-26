import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: DataSiswaPage(),
  ));
}

class DataSiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StudentListPage(),
    );
  }
}

class StudentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 6, right: 16, bottom: 5),
            color: Colors.greenAccent,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Kembali',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Data Siswa Kelas 10',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                    shape: StadiumBorder(),
                  ),
                  child: const Text('Tambah Siswa',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return StudentCard();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, color: Colors.white, size: 30),
            ),
            SizedBox(
              width: 34,
              child: CustomPaint(
                painter: DiagonalLinePainter(),
                size: const Size(16, 60),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seruan Ndi Jonatan Giawa',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text('IF B Malam'),
                  Text('3312311077', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagonalLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5;

    canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
