import 'package:flutter/material.dart';
import 'bab_page.dart';
import 'riwayat_nilai.dart'; // Import your target page
import 'profil.dart'; // Import your profil page
import 'kelas_screen.dart'; // Import your profil page
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Fungsi untuk tombol navigasi ke halaman riwayat_nilai.dart dan profil.dart
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to RiwayatNilaiPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RiwayatNilaiPage()),
      );
    } else if (index == 2) {
      // Navigate to ProfilPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilPage()),
      );
    }
  }

  Future<String> getUserData() async {
    // Ambil token dari shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token tidak ditemukan');
    }

    final url = Uri.parse(
        'http://10.0.2.2:8000/api/me'); // Ganti dengan URL yang sesuai

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token', // Kirim token di header
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['name'] != null) {
        return responseData['name']; // Mengembalikan nama pengguna
      } else {
        throw Exception('Nama tidak ditemukan');
      }
    } else {
      throw Exception('Gagal mendapatkan data user');
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
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Hi!',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    FutureBuilder<String>(
                      future: getUserData(), // Panggil getUserData dengan token
                      builder: (context, snapshot) {
                        // Menunggu data
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        // Jika ada error
                        else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        // Jika berhasil mendapatkan data
                        else if (snapshot.hasData) {
                          return Text(
                            snapshot.data ??
                                'Nama tidak ditemukan', // Menampilkan nama pengguna
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }

                        // Jika tidak ada data
                        return const Text('Tidak ada data');
                      },
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Tambahkan fungsi aksi untuk ikon profil di sini
                  },
                  child: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.black,
                    child: Icon(
                      Icons.person,
                      size: 25,
                      color: Colors.white,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigate to BabPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KelasPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 180),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                elevation: 5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MATERI',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/mateributton.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                // Handle Pengaturan action here
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 180),
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                elevation: 5,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'PENGATURAN',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      'assets/images/pengaturanbutton.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
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
