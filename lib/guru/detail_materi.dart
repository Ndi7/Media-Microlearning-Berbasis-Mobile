import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_learning_berbasis_mobile/guru/kuis_detail.dart';
import 'package:media_learning_berbasis_mobile/guru/video_player_page.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:media_learning_berbasis_mobile/services/detail_materi_services.dart';
import 'package:path/path.dart' as p;

class MateriDetailPage extends StatefulWidget {
  final Map<String, dynamic> materi;

  const MateriDetailPage({super.key, required this.materi});

  @override
  State<MateriDetailPage> createState() => _MateriDetailPageState();
}

class _MateriDetailPageState extends State<MateriDetailPage> {
  List<dynamic> _kuisList = [];
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _kuisList = widget.materi['kuis'] ?? [];

    final String? filePath = widget.materi['file_path'];

    if (filePath != null && p.extension(filePath) == '.mp4') {
      final String videoUrl = filePath.startsWith('http')
          ? filePath
          : 'http://10.0.2.2:8000/storage/$filePath';
      _videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {}); // Refresh UI when video is initialized
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? filePath = widget.materi['file_path'];
    final materi = widget.materi;
    if (filePath == null) {
      return const Center(child: Text('File tidak tersedia'));
    }

    final String extension = p.extension(filePath);

    if (extension == '.mp4' && _videoController != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Materi',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(materi),
                  const SizedBox(height: 20),
                  _buildDescription(materi),
                  const SizedBox(height: 20),
                  _buildKuisSection(),
                  _videoController!.value.isInitialized
                      ? Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            ),
                            // Video controls overlay
                            Container(
                              color: Colors.black54, // Semi-transparent overlay
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  VideoProgressIndicator(
                                    _videoController!,
                                    allowScrubbing: true,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            if (_videoController!
                                                .value.isPlaying) {
                                              _videoController!.pause();
                                            } else {
                                              _videoController!.play();
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          _videoController!.value.isPlaying
                                              ? Icons.pause
                                              : Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '${_formatDuration(_videoController!.value.position)} / ${_formatDuration(_videoController!.value.duration)}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _videoController!
                                              .seekTo(Duration.zero);
                                        },
                                        icon: const Icon(
                                          Icons.replay,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Detail Materi',
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(materi),
                  const SizedBox(height: 20),
                  _buildDescription(materi),
                  const SizedBox(height: 20),
                  _buildFileButton(context, filePath),
                  const SizedBox(height: 30),
                  _buildKuisSection()
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTitleRow(Map<String, dynamic> materi) {
    return Row(
      children: [
        const Icon(
          Icons.book,
        ),
        const SizedBox(width: 12),
        Text(
          materi['judul'] ?? 'Judul tidak tersedia',
          style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Color(0xff2C3E50)),
        ),
      ],
    );
  }

  Widget _buildDescription(Map<String, dynamic> materi) {
    return Text(
      materi['deskripsi'] ?? 'Deskripsi tidak tersedia',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Color(0xff333333),
      ),
    );
  }

  Widget _buildKuisSection() {
    if (_kuisList.isEmpty) {
      return const SizedBox
          .shrink(); // Jangan tampilkan apa-apa jika tidak ada kuis
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kuis Materi',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 7),
        ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 5),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _kuisList.length,
          itemBuilder: (context, index) {
            final kuis = _kuisList[index];
            return Card(
              color: Colors.black,
              child: ListTile(
                title: Text(
                  kuis['judul_kuis'],
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'Durasi: ${kuis['durasi'] ?? 'Tidak ditentukan'}',
                  style: GoogleFonts.manrope(color: Colors.white),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFAD02C), // button color
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Konfirmasi Mulai Kuis"),
                          content: const SizedBox(
                            height: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    '\u2022 Pastikan Anda memiliki koneksi internet yang stabil sebelum memulai kuis.'),
                                SizedBox(height: 15),
                                Text(
                                    '\u2022 Kuis ini akan dikirimkan secara otomatis ketika waktunya habis.'),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KuisDetailPage(
                                      kuis: kuis,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Mulai',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Mulai Kuis',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

Widget _buildFileButton(BuildContext context, String? filePath) {
  if (filePath == null) return const Text('File tidak tersedia');

  return ElevatedButton(
    onPressed: () => _handleFileDownload(context, filePath),
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff005AFF), // button color
      foregroundColor: Colors.white,
    ),
    child: const Text(
      'Buka Materi',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Future<void> _handleFileDownload(BuildContext context, String filePath) async {
  final String fileUrl = filePath.startsWith('http')
      ? filePath
      : 'http://10.0.2.2:8000/storage/$filePath';
  log('URL file: $fileUrl');

  try {
    final downloadedFilePath =
        await FileDownloadService.downloadFile(context, url: fileUrl);

    if (downloadedFilePath != null && File(downloadedFilePath).existsSync()) {
      log('File berhasil diunduh: $downloadedFilePath');

      await FileHandlerService.handleDownloadedFile(
          context, fileUrl, downloadedFilePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunduh file')),
      );
    }
  } catch (e) {
    log('Error saat mengunduh file: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terjadi kesalahan saat mengunduh file')),
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

String _formatDuration(Duration duration) {
  final minutes = duration.inMinutes.toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
