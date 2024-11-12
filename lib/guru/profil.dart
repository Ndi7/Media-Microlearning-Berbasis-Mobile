import 'package:flutter/material.dart';
import '../siswa/ubahsandi.dart'; // Pastikan untuk mengimpor halaman Ubah Sandi
import '../siswa/ubahnohp_page.dart'; // Pastikan untuk mengimpor halaman Ubah Nomor HP
import '../login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //panggil token dari login
    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }

    //fungsi Logout
    Future<void> logoutUser() async {
      String? token = await getToken();
      if (token != null) {
        final url = Uri.parse('http://10.0.2.2:8000/api/logout');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $token',
          },
        );
        if (response.statusCode == 200) {
          // Navigasi ke halaman login dan hapus token dari `SharedPreferences`
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        } else {
          print('Logout gagal. Status code: ${response.statusCode}');
        }
      } else {
        print('Token tidak ditemukan');
      }
    }

    //info pengguna dari api
    Future<Map<String, dynamic>> getUserData() async {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final url = Uri.parse('http://10.0.2.2:8000/api/me');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Parsing JSON menjadi Map<String, dynamic>
        return jsonDecode(response.body);
      } else {
        throw Exception('Gagal mengambil data pengguna');
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0), // Atur tinggi AppBar
        child: Container(
          decoration: const BoxDecoration(
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
                      color: const Color(0xFF000000),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 0.5), // Jarak antara ikon dan teks
                    const Text(
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
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future:
                  getUserData(), // Pastikan ini benar-benar mendapatkan Map<String, dynamic>
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('Data tidak ditemukan');
                } else {
                  final userData = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Info Pengguna',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                          'Nama', userData['name'] ?? 'Tidak ditemukan'),
                      _buildInfoRow('NUPTK', userData['nuptk'] ?? 'Tidak ada'),
                      _buildInfoRow('Status', userData['role'] ?? 'Tidak ada'),
                      _buildInfoRow(
                          'Email', userData['email'] ?? 'Tidak ditemukan'),
                      _buildInfoRowWithLink('Sandi', '*******', 'Ubah', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UbahSandipage()),
                        );
                        //TODO integrasi api crud siswa
                      }),
                    ],
                  );
                }
              },
            ),
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
                  logoutUser();
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
