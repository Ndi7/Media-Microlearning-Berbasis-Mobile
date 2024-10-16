import 'package:flutter/material.dart';

class DataSiswaPage extends StatelessWidget {
  const DataSiswaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF92E3A9),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Kembali',
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0xFF92E3A9), thickness: 1),
            const ProfileInfo(label: 'Nama', value: 'Seruan Ndi Jonatan Giawa'),
            const ProfileInfo(label: 'NISN', value: '3312311077'),
            const ProfileInfo(label: 'Jenis Kelamin', value: 'Laki-laki'),
            const ProfileInfo(label: 'Tempat Lahir', value: 'Batam'),
            const ProfileInfo(label: 'Tanggal Lahir', value: '01 Januari 2001'),
            const ProfileInfo(label: 'Kelas', value: '12'),
            const ProfileInfo(label: 'Agama', value: 'Kristen'),
            const ProfileInfo(label: 'Alamat', value: 'Simp. Dam Mukakuning'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                    onPressed: () {
                      //  fungsi hapus siswa di sini
                    },
                    child: const Text('Hapus Siswa'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfo({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Sesuaikan lebar jika perlu
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text(':'),
              ],
            ),
          ),
          const SizedBox(width: 10), // Jarak antara ':' dan nilai
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
