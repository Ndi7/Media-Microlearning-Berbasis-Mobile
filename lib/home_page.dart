import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: PreferredSize(
  preferredSize: Size.fromHeight(110.0), // Atur tinggi AppBar
  child: Container(
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255), // Ubah warna latar belakang
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)), // Radius bawah
      boxShadow: [ // Menambahkan bayangan
        BoxShadow(
          color: const Color.fromARGB(255, 176, 176, 176).withOpacity(0.10), // Warna bayangan dengan transparansi
          spreadRadius: 5, // Radius penyebaran bayangan
          blurRadius: 7,  // Radius blur bayangan
          offset: Offset(0, 3), // Posisi bayangan (x, y)
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0), // Tambahkan padding untuk jarak
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur elemen kiri dan kanan
        crossAxisAlignment: CrossAxisAlignment.end, // Rata bawah secara vertikal
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Mengatur rata kiri untuk teks
            mainAxisAlignment: MainAxisAlignment.end, // Menempatkan teks di bawah vertikal
            children: [
              Text(
                'Hi!',
                style: TextStyle(
                  fontSize: 16, // Ukuran font untuk sapaan
                  color: Colors.grey, // Ubah warna teks menjadi abu-abu
                ),
              ),
              Text(
                'Seruan Ndi Jonatan G',
                style: TextStyle(
                  fontSize: 20, // Ukuran font untuk nama
                  fontWeight: FontWeight.bold, // Membuat teks tebal
                  color: Colors.black, // Warna teks hitam
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              // Tambahkan fungsi aksi untuk ikon profil di sini
            },
            child: CircleAvatar(
              radius: 25, // Ukuran lingkaran untuk ikon profil
              backgroundColor: Colors.black, // Warna latar belakang ikon
              child: Icon(
                Icons.person,
                size: 30, // Ukuran ikon profil
                color: Colors.white, // Warna ikon profil
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),

      
      // Ubah warna latar belakang di sini
      backgroundColor: const Color.fromARGB(255, 155, 246, 181),  // Warna latar belakang hijau
      
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Column(
          children: [
            SizedBox(height: 50),

            // Materi Button
            ElevatedButton(
              onPressed: () {
                // Handle Materi action here
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, color: Colors.white),
                  SizedBox(width: 10),
                  Text('MATERI', style: TextStyle(color: Colors.white)),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 150),
                backgroundColor: Colors.teal, // Adjusted color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 5, // Subtle shadow effect
              ),
            ),
            SizedBox(height: 30),

            // Pengaturan Button
            ElevatedButton(
              onPressed: () {
                // Handle Pengaturan action here
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings, color: Colors.white),
                  SizedBox(width: 10),
                  Text('PENGATURAN', style: TextStyle(color: Colors.white)),
                ],
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 150),
                backgroundColor: Colors.blueAccent, // Adjusted color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                ),
                elevation: 5, // Subtle shadow effect
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)), // Atur radius
        child: Container(
          height: 75, // Atur tinggi sesuai kebutuhan
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Warna bayangan dengan transparansi
                spreadRadius: 5, // Radius penyebaran bayangan
                blurRadius: 7,  // Radius blur bayangan
                offset: Offset(0, -3), // Bayangan muncul di atas, jadi offset negatif
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Favorites',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),




    );
  }
}
