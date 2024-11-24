import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'siswa/home_page.dart'; // Import halaman HomePage
import 'guru/home_page.dart'; // Import halaman HomePage
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _passwordVisible = false; // Menyimpan status visibility password
  String errorMessage = ''; // Variabel untuk menyimpan pesan kesalahan

  Future<void> loginUser(String email, String password) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/login');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['message'] == 'Login sukses') {
        // Ambil role dari respons (misalnya, role disimpan di responseData)
        String role = responseData['role']; // Pastikan role ada di data respons
        final token = responseData['token'];
        if (token != null) {
          // Menyimpan token menggunakan SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          log("Login berhasil! Token disimpan.");
        }
        // Cek role dan arahkan ke halaman yang sesuai
        if (role == 'guru') {
          if (!mounted) return;
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePageGuru()),
          );
        } else {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        // Tampilkan pesan kesalahan jika ada
        ('Login gagal: ${responseData['message']}');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Berhasil'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Login gagal, tampilkan pesan kesalahan
      setState(() {});
      errorMessage = 'email atau password salah!';
      ('Login gagal: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Image.asset('assets/images/logo.png'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                filled: true,
                fillColor: const Color(0xffF2F2F2),
                labelStyle: const TextStyle(
                    color: Color(0xff8A8A8A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                errorText: errorMessage.isNotEmpty
                    ? errorMessage
                    : null, // Menampilkan pesan error
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.blue, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: passwordController,
              obscureText:
                  !_passwordVisible, // Mengatur apakah password disembunyikan atau tidak
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                fillColor: const Color(0xffF2F2F2),
                labelStyle: const TextStyle(
                    color: Color(0xff8A8A8A),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                errorText: errorMessage.isNotEmpty
                    ? errorMessage
                    : null, // Menampilkan pesan error
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.red, width: 1),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible =
                          !_passwordVisible; // Mengubah status visibility
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Menjalankan fungsi login
              loginUser(
                emailController.text,
                passwordController.text,
              );
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xFF4AB3FF)),
              // backgroundColor: Color.fromARGB(12, 3, 3, 3),
            ),
            child: const Text(
              'Masuk',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
