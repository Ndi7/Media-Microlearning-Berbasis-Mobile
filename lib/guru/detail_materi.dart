import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class MateriDetailPage extends StatefulWidget {
  final Map<String, dynamic> materi;

  const MateriDetailPage({super.key, required this.materi});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  Future<String?> _downloadFile(String url) async {
    try {
      // final response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final filePath = '${dir.path}/${Uri.parse(url).pathSegments.last}';
      Dio dio = Dio();
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            log('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );
      // Validasi keberadaan file
      final file = File(filePath);
      if (await file.exists()) {
        log('File berhasil disimpan di: $filePath');
        return filePath;
      } else {
        throw Exception('File tidak ditemukan setelah unduhan selesai.');
      }
    } catch (e) {
      log('Error downloading file: $e');
      return null;
    }
  }

  // Fungsi untuk mengecek apakah file adalah PDF
  bool isPdf(String filePath) {
    return filePath.toLowerCase().endsWith('.pdf');
  }

  // Fungsi untuk mengecek apakah file adalah gambar
  bool isImage(String filePath) {
    return filePath.toLowerCase().endsWith('.jpg') ||
        filePath.toLowerCase().endsWith('.jpeg') ||
        filePath.toLowerCase().endsWith('.png');
  }

  // Fungsi untuk mengecek apakah file adalah video
  bool isVideo(String filePath) {
    return filePath.toLowerCase().endsWith('.mp4');
  }

  // Fungsi untuk mengecek apakah file adalah dokumen Word
  bool isDocx(String filePath) {
    return filePath.toLowerCase().endsWith('.docx');
  }

  @override
  Widget build(BuildContext context) {
    final String? filePath = widget.materi['file_path'];
    final materi = widget.materi;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Materi',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xffF6F6F6),
      ),
      backgroundColor: const Color(0xffF6F6F6),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Icon(Icons.book),
                  const SizedBox(width: 12),
                  Text(
                    materi['judul'] ?? 'Judul tidak tersedia',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                materi['deskripsi'] ?? 'Deskripsi tidak tersedia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              filePath != null
                  ? ElevatedButton(
                      onPressed: () async {
                        final String fileUrl =
                            'http://10.0.2.2:8000/storage/$filePath';
                        // final downloadedFilePath = await _downloadFile(fileUrl);
                        log('URL file: $fileUrl');
                        final downloadedFilePath = await _downloadFile(fileUrl);

                        if (downloadedFilePath != null &&
                            File(downloadedFilePath).existsSync()) {
                          log('File berhasil diunduh: $downloadedFilePath');
                          if (isPdf(downloadedFilePath)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PdfViewerPage(filePath: downloadedFilePath),
                              ),
                            );
                          } else if (isImage(downloadedFilePath)) {
                            // Jika file adalah gambar, buka menggunakan Image
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageViewerPage(
                                    filePath: downloadedFilePath),
                              ),
                            );
                          } else if ((isVideo(downloadedFilePath))) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerPage(
                                  filePath: downloadedFilePath,
                                ),
                              ),
                            );
                          } else if (isDocx(downloadedFilePath)) {
                            // Jika file adalah dokumen Word, tangani sesuai kebutuhan
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('File dokumen Word belum didukung')),
                            );
                          } else {
                            // Tangani file selain PDF, gambar, video, dan Word
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('File tidak didukung')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Gagal mengunduh file')),
                          );
                        }
                      },
                      child: const Text(
                        'Buka Materi',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const Text('File tidak tersedia'),
            ])),
      ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String filePath;

  const PdfViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: filePath,
      ),
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  final String filePath;

  const ImageViewerPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Viewer'),
      ),
      body: Center(
        child: Image.file(File(filePath)),
      ),
    );
  }
}

class VideoPlayerPage extends StatefulWidget {
  final String filePath;

  const VideoPlayerPage({super.key, required this.filePath});

  @override
  VideoPlayerPageState createState() => VideoPlayerPageState();
}

class VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
