import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true; // Variabel untuk mengatur visibility password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcome Text
            const Text(
              'Selamat Datang kembali!',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Placeholder Image menggunakan Image.asset
            Image.asset(
              'assets/images/login.jpeg', // Path gambar dari aset lokal
              height: 300, // Atur tinggi gambar
            ),
            const SizedBox(height: 1), // Ruang antara elemen

            // Email Field
            SizedBox(
              width: 350, // Tentukan lebar kolom TextField
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(40), // Mengatur radius sudut
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Password Field
            SizedBox(
              width: 350, // Tentukan lebar kolom TextField
              child: TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Sandi',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(40), // Mengatur radius sudut
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText; // Toggle visibility
                      });
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Forgot Password
            Align(
              alignment: const FractionalOffset(0.8,
                  0.0), // Geser ke kanan (0.1) dan tetap di tengah vertikal (0.0)
              child: TextButton(
                onPressed: () {
                  // Handle forgot password action here
                },
                child: const Padding(
                  padding: EdgeInsets.only(
                      bottom: 3.0), // Adjust padding to lift underline
                  child: Text(
                    'Lupa Sandi?',
                    style: TextStyle(
                      color: Colors.blue, // Warna teks biru
                      // decoration: TextDecoration.underline, // Garis bawah pada teks
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            ElevatedButton(
              onPressed: () {
                // Navigate to HomePage after successful login
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
                backgroundColor: Colors.blue, // Warna background tombol
                foregroundColor: Colors.white, // Warna teks (foreground) tombol
              ),
              child: const Text('Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}
