import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_learning_berbasis_mobile/guru/detail_materi.dart';
import 'package:media_learning_berbasis_mobile/guru/video_player_page.dart';
import 'package:path_provider/path_provider.dart';

enum FileType { pdf, image, video, docx, unsupported }

class FileDownloadService {
  static Future<String?> downloadFile(
    BuildContext context, {
    required String url,
    Function(int, int)? onProgress,
  }) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 90),
        sendTimeout: const Duration(seconds: 30),
      ));

      final dir = await getTemporaryDirectory();
      final fileName = Uri.parse(url).pathSegments.last;
      final filePath = '${dir.path}/$fileName';

      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            log('Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
            onProgress?.call(received, total);
          }
        },
        options: Options(
          headers: {
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate',
          },
        ),
      );

      final file = File(filePath);
      return file.existsSync() ? filePath : null;
    } on DioException catch (e) {
      _showErrorSnackBar(
          context, 'Gagal mengunduh file: ${e.message ?? "Unknown error"}');
      return null;
    } catch (e) {
      _showErrorSnackBar(context, 'Gagal mengunduh file: $e');
      return null;
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    log(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}

//file checker
class FileUtils {
  static FileType getFileType(String filePath) {
    final lowerPath = filePath.toLowerCase();
    if (lowerPath.endsWith('.pdf')) return FileType.pdf;
    if (lowerPath.endsWith('.jpg') ||
        lowerPath.endsWith('.jpeg') ||
        lowerPath.endsWith('.png')) return FileType.image;
    if (lowerPath.endsWith('.mp4')) return FileType.video;
    if (lowerPath.endsWith('.docx')) return FileType.docx;
    return FileType.unsupported;
  }
}

class FileHandlerService {
  static Future<void> handleDownloadedFile(
      BuildContext context, String fileUrl, String downloadedFilePath) async {
    final fileType = FileUtils.getFileType(downloadedFilePath);

    switch (fileType) {
      case FileType.pdf:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PdfViewerPage(filePath: downloadedFilePath),
          ),
        );
        break;
      case FileType.image:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerPage(filePath: downloadedFilePath),
          ),
        );
        break;
      case FileType.video:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerPage(filePath: fileUrl),
          ),
        );
        break;
      case FileType.docx:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File dokumen Word belum didukung')),
        );
        break;
      case FileType.unsupported:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File tidak didukung')),
        );
        break;
    }
  }
}
