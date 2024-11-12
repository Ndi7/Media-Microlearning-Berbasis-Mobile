import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
import 'package:media_learning_berbasis_mobile/siswa/home_page.dart';
import 'bab_page.dart';
// import 'riwayat_nilai.dart'; // Import halaman tujuan
import 'profil.dart'; // Import halaman profil
import 'Kelas.dart'; // Import halaman kelas

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  _KelasPageState createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  int _selectedIndex = 1;

  // Fungsi untuk tombol navigasi ke halaman riwayat_nilai.dart dan profil.dart
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigasi ke RiwayatNilaiPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePageGuru()),
      );
    } else if (index == 2) {
      // Navigasi ke ProfilPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(15.0)),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 176, 176, 176).withOpacity(0.10),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 50.0, bottom: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors
                      .click, // Mengubah kursor menjadi pointer
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 155, 246, 181),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KelasButton(
              text: 'Biologi Kelas 10',
              height: 170, // Ketinggian khusus
              radius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Radius sudut kiri atas
                topRight: Radius.circular(30), // Radius sudut kanan atas
                bottomLeft: Radius.circular(30), // Radius sudut kiri bawah
                bottomRight: Radius.circular(0), // Radius sudut kanan bawah
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BabPage(className: 'Biologi Kelas 10'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10), // Spasi yang disesuaikan
            KelasButton(
              text: 'Biologi Kelas 11',
              height: 170, // Ketinggian khusus
              radius: const BorderRadius.only(
                topLeft: Radius.circular(0), // Radius sudut kiri atas
                topRight: Radius.circular(30), // Radius sudut kanan atas
                bottomLeft: Radius.circular(30), // Radius sudut kiri bawah
                bottomRight: Radius.circular(30), // Radius sudut kanan bawah
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const BabPage(className: 'Biologi Kelas 11'),
                  ),
                );
              },
            ),
            const SizedBox(height: 10), // Spasi yang disesuaikan
            KelasButton(
              text: 'Biologi Kelas 12',
              height: 170, // Ketinggian khusus
              radius: const BorderRadius.only(
                topLeft: Radius.circular(30), // Radius sudut kiri atas
                topRight: Radius.circular(30), // Radius sudut kanan atas
                bottomLeft: Radius.circular(30), // Radius sudut kiri bawah
                bottomRight: Radius.circular(0), // Radius sudut kanan bawah
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BabPage(className: 'Biologi Kelas 12'),
                  ),
                );
              },
            ),
          ],
        ),
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

// KelasButton dengan ukuran dan radius sudut yang dapat diatur
class KelasButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height; // Parameter tinggi
  final BorderRadiusGeometry radius; // Parameter untuk radius sudut

  const KelasButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 100, // Default tinggi
    required this.radius, // Radius sudut yang diperlukan
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize:
            Size(double.infinity, height), // Menggunakan tinggi yang ditentukan
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: radius, // Menggunakan radius yang ditentukan
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
