import 'package:flutter/material.dart';

class LupaSandiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), // Jarak dari atas
            Text(
              'Lupa Sandi', // Judul halaman
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Jarak antara judul dan teks berikutnya
            Text(
              'Masukkan email Anda, dan tunggu kode verifikasi akan dikirimkan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                labelText: 'Masukkan Email',
                filled: true,
                fillColor: Colors.grey[200], // Latar belakang abu-abu terang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                  borderSide: BorderSide.none, // Menghilangkan border
                ),
              ),
            ),

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    // Handle verification code request
                  },
                  child: Text(
                    'Minta Kode Verifikasi',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Masukkan Kode Verifikasi',
                filled: true,
                fillColor: Colors.grey[200], // Latar belakang abu-abu terang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                  borderSide: BorderSide.none, // Menghilangkan border
                ),
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke Halaman Atur Lupa Sandi
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AturLupaSandiPage()),
                );
              },
              child: Text(
                'Berikutnya',
                style: TextStyle(color: Colors.white), // Warna teks putih
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar tombol biru
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

class AturLupaSandiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), // Jarak dari atas
            Text(
              'Atur Lupa Sandi', // Judul halaman
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            TextField(
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                filled: true,
                fillColor: Colors.grey[200], // Latar belakang abu-abu terang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                  borderSide: BorderSide.none, // Menghilangkan border
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Konfirmasi Kata Sandi',
                filled: true,
                fillColor: Colors.grey[200], // Latar belakang abu-abu terang
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                  borderSide: BorderSide.none, // Menghilangkan border
                ),
              ),
            ),

            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                // Proses reset kata sandi
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.white), // Warna teks putih
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Warna latar tombol biru
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50), // Sudut melengkung
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
