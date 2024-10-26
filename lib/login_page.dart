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
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[100], // Latar belakang abu-abu terang
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none, // Menghilangkan border
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
                  filled: true,
                  fillColor: Colors.grey[200], // Latar belakang abu-abu terang
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none, // Menghilangkan border
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
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
              alignment: const FractionalOffset(0.8, 0.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lupa-sandi'); // Navigate to LupaSandiPage
                },
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 3.0),
                  child: Text(
                    'Lupa Sandi?',
                    style: TextStyle(
                      color: Colors.blue,
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
