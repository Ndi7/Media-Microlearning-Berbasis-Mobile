import 'package:flutter/material.dart';

class GantiNoHp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(120,65),
        child: AppBar(
        title: const Text('Ubah No Telepon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Aksi ketika tombol kembali ditekan
          },
        ),
        backgroundColor: const Color.fromARGB(255, 118, 251, 153),
        elevation: 0,
        foregroundColor: Colors.black,
        )
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 50, 50, 15),
            child: TextField(
              maxLength: 15,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 158, 245, 179),
                labelText: 'No Telepon',
                hintText: 'Ubah No Telepon',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 30),
            child: TextField(
              maxLength: 15,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color.fromARGB(255, 158, 245, 179),
                labelText: 'Konfirmasi',
                hintText: 'Konfirmasi No Telepon',
                prefixIcon: Icon(Icons.phone_forwarded),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            ),

             SizedBox(height: 20), // Jarak antara TextField dan tombol
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50), // Sesuaikan padding tombol dengan input
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Sebarkan tombol
              children: [
                // Tombol Batal
                SizedBox(
                  width: 120, // Lebar tombol Batal
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi saat tombol "Batal" ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300], // Warna tombol Batal
                      foregroundColor: Colors.black, // Warna teks tombol Batal
                      minimumSize: Size(0, 40), // Ukuran tombol
                    ),
                    child: Text('Batal'),
                  ),
                ),
                SizedBox(width: 10),
                // Tombol Ubah
                SizedBox(
                  width: 120, // Lebar tombol Ubah
                  child: ElevatedButton(
                    onPressed: () {
                      // Aksi saat tombol "Ubah" ditekan
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Warna tombol Ubah
                      foregroundColor: Colors.white, // Warna teks tombol Ubah
                      minimumSize: Size(0, 40), // Ukuran tombol
                    ),
                    child: Text('Ubah'),
                  ),
                ),
              ],
            ),
          ),
        ]
      )
      );
      }
}