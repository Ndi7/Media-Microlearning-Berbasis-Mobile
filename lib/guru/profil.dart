import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart';
import '../siswa/ubahsandi.dart'; // Pastikan untuk mengimpor halaman Ubah Sandi
import '../siswa/ubahnohp_page.dart'; // Pastikan untuk mengimpor halaman Ubah Nomor HP
import '../login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

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
      final apiUrl = dotenv.env['API_URL']!;
      if (token != null) {
        final url = Uri.parse('$apiUrl/logout');
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
            MaterialPageRoute(builder: (context) => const LoginPage()),
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
      final apiUrl = dotenv.env['API_URL']!;
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final url = Uri.parse('$apiUrl/me');
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
        preferredSize: const Size.fromHeight(70.0), // Tinggi AppBar
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 124, 226, 153), // Warna latar belakang
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.0), // Membulatkan sudut bawah
            ),
          ),
          child: AppBar(
            title: const Text('Pengaturan Akun'),
            backgroundColor:
                Colors.transparent, // Mengatur warna AppBar menjadi transparan
            elevation: 0, // Menghilangkan bayangan
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor:
                  Color.fromARGB(255, 124, 226, 153), // Latar belakang hitam
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white, // Warna ikon menjadi putih
              ),
            ),
            const SizedBox(width: 10),
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
                          'Nama :', userData['name'] ?? 'Tidak ditemukan'),
                      _buildInfoRow(
                          'NUPTK :', userData['nuptk'] ?? 'Tidak ada'),
                      _buildInfoRow(
                          'Status :', userData['role'] ?? 'Tidak ada'),
                      _buildInfoRow(
                          'Email :', userData['email'] ?? 'Tidak ditemukan'),
                      _buildInfoRowWithLink('Sandi', '*******', 'Ubah', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UbahSandipage()),
                        );
                        //TODO integrasi api crud siswa
                      }),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Lainnya',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
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
                child: const Text(
                  'Keluar',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16), // Tambahan jarak di bawah tombol Keluar
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3), // Small space between title and content
          Padding(
            padding: const EdgeInsets.only(left: 27.0), // Geser konten ke kanan
            child: Text(
              content,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 3), // Small space between title and content
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 27.0), // Geser konten ke kanan
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onPressed,
                child: Text(
                  linkText,
                  style: const TextStyle(
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
