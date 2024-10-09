import 'package:flutter/material.dart';

class BabPage extends StatefulWidget {
  const BabPage({super.key});

  @override
  _BabPageState createState() => _BabPageState();
}

class _BabPageState extends State<BabPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // Prevent unnecessary navigation

    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    if (index == 0) {
      page = const BabPage();
    } else if (index == 2) {
      page = const BabPage();
    } else {
      page = const BabPage(); // Stay on BabPage
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _addBab() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Tambah Bab"),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nama Bab",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Bab",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementasi logika penyimpanan di sini
                Navigator.of(context).pop(); // Tutup dialog setelah menyimpan
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Bab"),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nama Bab",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Deskripsi Bab",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () {
                // Implementasi logika penyimpanan di sini
                Navigator.of(context).pop(); // Tutup dialog setelah menyimpan
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(top: 30.0, left: 30.0),
          child: Text(
            'Bab Page',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        foregroundColor: Colors.black,
        toolbarHeight: 90,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      backgroundColor: const Color(0xFF9BF6B5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 26, 16, 16),
            child: Row(
              children: [
                // TextField for searching
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Bab',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                    onChanged: (value) {
                      // Implement search functionality here
                    },
                  ),
                ),
                const SizedBox(width: 10), // Space between search and buttons
                // Edit Bab Button (Green color)
                ElevatedButton(
                  onPressed:
                      _showEditDialog, // Tampilkan pop-up saat tombol di klik
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: Colors.yellow, // Set button to yellow
                  ),
                  child: const Text('Edit Bab'),
                ),
                const SizedBox(width: 10), // Space between buttons
                // Tambah Bab Button (Blue color)
                ElevatedButton(
                  onPressed: _addBab,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    backgroundColor: Colors.blue, // Set button to blue
                  ),
                  child: const Text('Tambah Bab'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'Bab ${index + 1}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            // Implement delete functionality here
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFFFFF).withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const [
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
