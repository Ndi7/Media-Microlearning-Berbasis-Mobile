import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/home_page.dart';
import 'package:media_learning_berbasis_mobile/siswa/home_page.dart';
import 'bab_page.dart';
// import 'riwayat_nilai.dart'; // Import halaman tujuan
import 'profil.dart'; // Import halaman profil
import 'kelas_screen.dart'; // Import halaman kelas

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
                GestureDetector(
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
              ],
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 155, 246, 181),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BabPage(),
              ),
            );
          },
          child: const SizedBox(
            width: 350,
            height: 170,
            child: Card(
                child: Center(
              child: Text(
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  'Kelas 12'),
            )),
            // radius: const BorderRadius.all(Radius.circular(20)),
            //
          ),
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
