import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF51CC0F), // Set the primary color
      ),
      home: UploadForm(),
    );
  }
}

class UploadForm extends StatefulWidget {
  @override
  _UploadFormState createState() => _UploadFormState();
}

class _UploadFormState extends State<UploadForm> {
  List<Map<String, String>> _files = []; // List to store file names and paths
  List<Map<String, String>> _links = []; // List to store link names and URLs
  bool isUploaded = false; // To track if something is uploaded

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed, // Trigger confirmation dialog when back is pressed
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF51CC0F), // Set AppBar color
          title: Text('Kembali'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Judul Materi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Deskripsi Materi (opsional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              Text('Lampirkan', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentButton(Icons.cloud_upload_outlined, 'Drive', _openDrive),
                  _buildAttachmentButton(Icons.file_upload_outlined, 'Upload', _openFilePicker),
                  _buildAttachmentButton(Icons.link_outlined, 'Link', () => _openLinkDialog(context)),
                ],
              ),
              SizedBox(height: 20),
              // Display the selected files or links and add delete buttons
              if (_files.isNotEmpty || _links.isNotEmpty) ...[
                Text('Materi yang akan diunggah:', style: TextStyle(fontWeight: FontWeight.bold)),
                for (var file in _files) ...[
                  ListTile(
                    title: Text('${file['name']}', style: TextStyle(color: Colors.black)),
                    subtitle: Text(file['path']!),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteFile(file),
                    ),
                    onTap: () {
                      _openFile(file['path']!);
                    },
                  ),
                ],
                for (var link in _links) ...[
                  ListTile(
                    title: Text('${link['name']}', style: TextStyle(color: Colors.black)),
                    subtitle: Text(link['url']!),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDeleteLink(link),
                    ),
                    onTap: () {
                      _launchURL(link['url']!);
                    },
                  ),
                ],
              ] else
                Text('No file or link added yet.'),
              SizedBox(height: 20),
              // Tombol Selesai
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isUploaded = true; // Mark as uploaded
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Materi berhasil disimpan!')),
                    );
                  },
                  child: Text('Selesai'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 113, 218, 247), // Background color changed to #04283e
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    textStyle: TextStyle(
                      color: Colors.black,  // Text color changed to white
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, Function onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.black, size: 40),
          onPressed: () {
            onPressed();
          },
        ),
        Text(label),
      ],
    );
  }

  void _openDrive() {
    // Simulate opening Google Drive, set a sample file
    _showNameInputDialog(context, (name) {
      setState(() {
        _files.add({'name': name, 'path': "https://drive.google.com/samplefile"});
        isUploaded = true;
      });
    });
  }

  void _openFilePicker() async {
    // Open file picker to pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String? filePath = result.files.single.path;
      _showNameInputDialog(context, (name) {
        setState(() {
          _files.add({'name': name, 'path': filePath!});
          isUploaded = true;
        });
      });
    } else {
      print('No file selected');
    }
  }

  void _openLinkDialog(BuildContext context) {
    // Show dialog to input link
    TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Masukkan Link"),
          content: TextField(
            controller: linkController,
            decoration: InputDecoration(hintText: "Enter URL"),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Kirim"),
              onPressed: () {
                String url = linkController.text;
                if (url.isNotEmpty && Uri.tryParse(url)?.hasAbsolutePath == true) {
                  _showNameInputDialog(context, (name) {
                    setState(() {
                      _links.add({'name': name, 'url': url});
                      isUploaded = true;
                    });
                    Navigator.of(context).pop();
                  });
                } else {
                  print("Invalid URL");
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showNameInputDialog(BuildContext context, Function(String) onSubmit) {
    // Dialog to input the name for a file or link
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Nama Materi"),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(hintText: "Masukkan Nama Materi"),
          ),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Kirim"),
              onPressed: () {
                String name = nameController.text;
                if (name.isNotEmpty) {
                  onSubmit(name);
                  Navigator.of(context).pop();
                } else {
                  print("Nama tidak boleh kosong");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to open a file (you can extend this with a file viewer)
  void _openFile(String filePath) {
    print("Opening file at: $filePath");
    // Here you can use a file viewer or a third-party plugin to open the file
  }

  // Function to confirm delete file
  void _confirmDeleteFile(Map<String, String> file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Materi"),
          content: Text("Apakah Anda yakin ingin menghapus file ini?"),
          actions: [
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () {
                _deleteFile(file);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete file
  void _deleteFile(Map<String, String> file) {
    setState(() {
      _files.remove(file);
    });
  }

  // Function to confirm delete link
  void _confirmDeleteLink(Map<String, String> link) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Hapus Link"),
          content: Text("Apakah Anda yakin ingin menghapus link ini?"),
          actions: [
            TextButton(
              child: Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Ya"),
              onPressed: () {
                _deleteLink(link);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to delete link
  void _deleteLink(Map<String, String> link) {
    setState(() {
      _links.remove(link);
    });
  }

  Future<bool> _onBackPressed() async {
    if (isUploaded) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin kembali tanpa menyimpan?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Tidak"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Ya"),
            ),
          ],
        ),
      ) ??
          false;
    } else {
      return true;
    }
  }
}
