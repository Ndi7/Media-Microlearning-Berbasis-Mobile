import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UbahSandipage(),
    );
  }
}

class UbahSandipage extends StatefulWidget {
  @override
  _UbahSandipageState createState() => _UbahSandipageState();
}

class _UbahSandipageState extends State<UbahSandipage> {
  bool _isPasswordVisible1 = false;
  bool _isPasswordVisible2 = false;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Warna latar belakang
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Input Sandi
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible1,
              decoration: InputDecoration(
                labelText: 'Sandi',
                filled: true,
                fillColor: Colors.green[100],
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible1
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible1 = !_isPasswordVisible1;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Menghilangkan border default
                ),
              ),
            ),
            SizedBox(height: 20),
            // Input Konfirmasi Sandi
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible2,
              decoration: InputDecoration(
                labelText: 'Konfirmasi',
                filled: true,
                fillColor: Colors.green[100],
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible2
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible2 = !_isPasswordVisible2;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Menghilangkan border default
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Agar tombol berada di kanan
              children: [
                // Tombol Batal
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Aksi untuk membatalkan perubahan
                  },
                  child: Text('Batal', style: TextStyle(color: Colors.black)),
                ),
                SizedBox(
                    width: 10), // Memberikan jarak antara tombol Batal dan Ubah
                // Tombol Ubah
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Aksi untuk menyimpan perubahan
                  },
                  child: Text('Ubah', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
