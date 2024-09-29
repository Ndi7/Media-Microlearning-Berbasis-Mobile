import 'package:flutter/material.dart';
import 'home_page.dart';
import 'detail_nilai.dart';
import 'profil.dart'; // Pastikan file profil.dart sudah ada

class RiwayatNilaiPage extends StatefulWidget {
  const RiwayatNilaiPage({super.key});

  @override
  _RiwayatNilaiPageState createState() => _RiwayatNilaiPageState();
}

class _RiwayatNilaiPageState extends State<RiwayatNilaiPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Tetap di halaman Riwayat Nilai
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatNilaiPage()),
      );
    } else if (index == 0) {
      // Navigasi ke HomePage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 2) {
      // Navigasi ke ProfilPage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProfilPage()), // Pastikan ProfilPage ada di profil.dart
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(
              top: 30.0, left: 30.0), // Atur padding sesuai kebutuhan
          child: Text(
            'Riwayat Nilai',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        foregroundColor: Colors.black,
        toolbarHeight: 110,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      backgroundColor: const Color(0xFF9BF6B5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Kuis',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
                filled: true, // Mengaktifkan pengisian warna latar belakang
                fillColor: Colors.white70, // Mengatur warna latar belakang
              ),
              onChanged: (value) {
                // kode fungsi search
              },
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: List.generate(6, (index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPenilaian(quizNumber: index + 1),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Kuis ${index + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Nilai',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
