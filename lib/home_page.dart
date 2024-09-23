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
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0), // Kurangi padding
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
                        fontSize: 15, // Ukuran font untuk sapaan
                        color: Colors.grey, // Ubah warna teks menjadi abu-abu
                      ),
                    ),
                    Text(
                      'Seruan Ndi Jonatan G',
                      style: TextStyle(
                        fontSize: 18, // Ukuran font untuk nama
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
                    radius: 15, // Ukuran lingkaran untuk ikon profil
                    backgroundColor: Colors.black, // Warna latar belakang ikon
                    child: Icon(
                      Icons.person,
                      size: 25, // Ukuran ikon profil
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
        padding: const EdgeInsets.all(20.0), // Kurangi padding
        child: Column(
          children: [
            SizedBox(height: 50), // Atur jarak vertikal lebih proporsional

            // Materi Button
            ElevatedButton(
              onPressed: () {
                // Handle Materi action here
              },
              child: Padding(
                padding: EdgeInsets.all(30.0), // Padding keseluruhan di sekitar konten
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MATERI', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, ),
                    ),
                    SizedBox(width: 10), // Jarak antara teks dan gambar
                    Image.asset(
                      'assets/images/mateributton.png', // Path gambar di folder assets
                      width: 120, // Ukuran lebar gambar yang lebih wajar
                      height: 120, // Ukuran tinggi gambar yang lebih wajar
                      fit: BoxFit.cover, // Menyesuaikan gambar dengan kotaknya
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 180), // Ukuran tombol
                backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),  // Radius sudut kiri atas
                    topRight: Radius.circular(30), // Radius sudut kanan atas
                    bottomLeft: Radius.circular(30), // Radius sudut kiri bawah
                    bottomRight: Radius.circular(0), // Radius sudut kanan bawah
                  ),
                ),
                elevation: 5, // Efek bayangan
              ),
            ),
            SizedBox(height: 60), // Jarak vertikal antara tombol dan elemen lainnya


            // Pengaturan Button
            ElevatedButton(
              onPressed: () {
                // Handle Materi action here
              },
              child: Padding(
                padding: EdgeInsets.all(30.0), // Padding keseluruhan di sekitar konten
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PENGATURAN', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold, ),
                    ),
                    SizedBox(width: 10), // Jarak antara teks dan gambar
                    Image.asset(
                      'assets/images/pengaturanbutton.png', // Path gambar di folder assets
                      width: 100, // Ukuran lebar gambar yang lebih wajar
                      height: 100, // Ukuran tinggi gambar yang lebih wajar
                      fit: BoxFit.cover, // Menyesuaikan gambar dengan kotaknya
                    ),
                  ],
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 180), // Ukuran tombol
                backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Warna tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(00),  // Radius sudut kiri atas
                    topRight: Radius.circular(30), // Radius sudut kanan atas
                    bottomLeft: Radius.circular(30), // Radius sudut kiri bawah
                    bottomRight: Radius.circular(30), // Radius sudut kanan bawah
                  ),
                ),
                elevation: 5, // Efek bayangan
              ),
            ),
            SizedBox(height: 40), // Jarak vertikal antara tombol dan elemen lainnya
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
                label: 'Nilai',
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
