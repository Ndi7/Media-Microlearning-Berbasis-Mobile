import 'package:flutter/material.dart';

class AddMateri extends StatelessWidget {
  const AddMateri({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Microlearning App',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MateriScreen(),
    );
  }
}

// Definisi Model Class Materi
class Materi {
  String title;
  String subtitle;
  String? quizQuestion; // New field for quiz questions
  IconData icon;

  Materi({
    required this.title,
    required this.subtitle,
    this.quizQuestion,
    required this.icon,
  });
}

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  _MateriScreenState createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  String searchQuery = '';
  List<Materi> materials = [];

  void addMaterial() {
    String newTitle = '';
    String newSubtitle = '';
    String selectedType = 'Materi'; // Default selection

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            // SetState di dalam dialog
            return AlertDialog(
              title: const Text('Tambah Konten Baru'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Judul'),
                    onChanged: (value) {
                      newTitle = value;
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Tanggal'),
                    onChanged: (value) {
                      newSubtitle = value;
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedType,
                    items:
                        <String>['Materi', 'Video', 'Kuis'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setStateDialog(() {
                        // Update state di dalam dialog
                        selectedType = newValue!;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                //tombol cancel
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Tutup dialog tanpa menyimpan
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Pastikan semua field diisi
                    if (newTitle.isEmpty || newSubtitle.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Semua field harus diisi')),
                      );
                    } else {
                      // Tambahkan materi baru ke daftar di widget utama
                      setState(() {
                        IconData icon;
                        if (selectedType == 'Materi') {
                          icon = Icons.book;
                        } else if (selectedType == 'Video') {
                          icon = Icons.videocam;
                        } else {
                          icon = Icons.question_answer;
                        }

                        materials.add(
                          Materi(
                            title: '$selectedType - $newTitle',
                            subtitle: newSubtitle,
                            quizQuestion:
                                null, // Tidak perlu input untuk pertanyaan kuis
                            icon: icon,
                          ),
                        );
                      });
                      Navigator.pop(
                          context); // Tutup dialog setelah menambahkan materi
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void editMaterial(int index) {
    TextEditingController titleController = TextEditingController();
    TextEditingController subtitleController = TextEditingController();
    TextEditingController quizController =
        TextEditingController(); // New controller for quiz question

    titleController.text = materials[index]
        .title
        .replaceAll(RegExp(r'^(Materi|Video|Kuis) - '), '');
    subtitleController.text = materials[index].subtitle;

    if (materials[index].quizQuestion != null) {
      quizController.text =
          materials[index].quizQuestion!; // Fill quiz question if present
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Materi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Judul Materi'),
              ),
              TextField(
                controller: subtitleController,
                decoration: const InputDecoration(labelText: 'Tanggal'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Tutup dialog tanpa menyimpan perubahan
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  materials[index].title = titleController.text;
                  materials[index].subtitle = subtitleController.text;
                  if (materials[index].quizQuestion != null) {
                    materials[index].quizQuestion =
                        quizController.text; // Update quiz question if present
                  }
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void deleteMaterial(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan'),
          content: const Text('Apakah kamu yakin ingin menghapus materi ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  materials.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text('Hapus'),
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
        title: const Text('Materi Pelajaran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 254, 253, 253),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari Materi Pelajaran',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: addMaterial,
                child: const Text('Tambah Materi'),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: materials.length,
              itemBuilder: (context, index) {
                if (materials[index]
                    .title
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase())) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5.0),
                    child: Card(
                      child: ListTile(
                        leading: Icon(
                          materials[index].icon,
                          size: 30,
                        ),
                        title: Text(materials[index].title),
                        subtitle: Text(materials[index].subtitle),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('${materials[index].title} dibuka')),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color:
                                  Colors.blue, // Warna biru untuk tombol edit
                              onPressed: () {
                                editMaterial(index);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color:
                                  Colors.red, // Warna biru untuk tombol hapus
                              onPressed: () {
                                deleteMaterial(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return Container(); // Return an empty container if the material doesn't match the search query
              },
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green.shade100,
    );
  }
}
