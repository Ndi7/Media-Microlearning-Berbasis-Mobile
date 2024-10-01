import 'package:flutter/material.dart';
import 'ubahsandi.dart'; // Pastikan untuk mengimpor halaman Ubah Sandi
import 'ubahnohp_page.dart'; // Pastikan untuk mengimpor halaman Ubah Nomor HP

void main() {
  runApp(MaterialApp(
    home: ProfilPage(),
  ));
}

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Atur tinggi AppBar
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF92E3A9), // Warna latar belakang
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(9.0), // Atur radius bawah
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 2.0, bottom: 2.0), // Atur padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Rata bawah
              crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
              children: [
                Row(
                  children: [
                    IconButton(
                      color: Color(0xFF000000),
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 0.5), // Jarak antara ikon dan teks
                    Text(
                      'Pengaturan Akun',
                      style: TextStyle(
                        fontSize: 20, // Ukuran font
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000), // Warna teks
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF000000), // Latar belakang hitam
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white, // Warna ikon menjadi putih
                  ),
                ),
                SizedBox(width: 10), // Jarak antara ikon dan teks
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Info Pengguna',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            _buildInfoRow('Username', 'seruan ndi jonatan g'),
            _buildInfoRow('NISN', '12345678'),
            _buildInfoRowWithLink('No Telepon', '085812345678', 'Ubah', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GantiNoHp()), // Arahkan ke UbahNoHPPage
              );
            }),
            _buildInfoRow('Email', 'natan@learning.com'),
            _buildInfoRowWithLink('Sandi', '*******', 'Ubah', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UbahSandipage()),
              );
            }),
            SizedBox(height: 16),
            Text(
              'Lainnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Tentang',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 2.0), // Geser tombol "Keluar" ke kanan
              child: TextButton(
                onPressed: () {
                  // Logika saat klik "Keluar"
                },
                child: Text(
                  'Keluar',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16), // Tambahan jarak di bawah tombol Keluar
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 3), // Small space between title and content
          Padding(
            padding: const EdgeInsets.only(left: 27.0), // Geser konten ke kanan
            child: Text(
              content,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowWithLink(
      String title, String content, String linkText, Function() onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 3), // Small space between title and content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 27.0), // Geser konten ke kanan
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onPressed,
                child: Text(
                  linkText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
