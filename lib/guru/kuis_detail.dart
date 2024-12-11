import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class KuisDetailPage extends StatefulWidget {
  final Map<String, dynamic> kuis;

  const KuisDetailPage({super.key, required this.kuis});

  @override
  _KuisDetailPageState createState() => _KuisDetailPageState();
}

class _KuisDetailPageState extends State<KuisDetailPage> {
  late int _durasi;
  Timer? _timer;

  int _convertDuration(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 0; // Jika format tidak sesuai
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    return hours * 3600 + minutes * 60 + seconds;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_durasi > 0) {
        setState(() {
          _durasi--;
        });
      } else {
        _timer?.cancel();
        _showTimeOutDialog();
      }
    });
  }

  void _showTimeOutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Waktu Habis'),
          content: const Text('Durasi pengerjaan kuis telah habis.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    @override
    void dispose() {
      _timer?.cancel();
      super.dispose();
    }

    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  //  variabel untuk melacak status jawaban
  final Map<int, String> _userAnswers = {};
  final Map<int, String> _selectedAnswers = {};
  late List<dynamic> _pertanyaan;
  // int _score = 0;
  bool _quizSubmitted = false;

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi Keluar'),
            content: const Text(
                'Apakah Anda yakin ingin keluar dari kuis? Jawaban Anda akan dinilai.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Tidak'),
              ),
              TextButton(
                onPressed: () {
                  _checkAnswers();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Ya'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _submitAnswer(int questionId, String answer) {
    setState(() {
      _userAnswers[questionId] = answer;
      _selectedAnswers[questionId] = answer;
    });
  }

  void _checkAnswers() {
    if (_quizSubmitted) return;

    int totalScore = 0;

    for (var soal in _pertanyaan) {
      final correctAnswer = soal['kunci_jawaban'];
      final userAnswer = _userAnswers[soal['id']];
      // Validasi jika jawaban user sesuai dengan kunci
      if (userAnswer != null && userAnswer == correctAnswer) {
        totalScore += 20; // Setiap jawaban benar mendapatkan +20
      }
    }

    setState(() {
      totalScore = totalScore;
      _quizSubmitted = true;
    });

    _showResultDialog(totalScore, _pertanyaan.length);
  }

  Widget _buildJawabanButton(Map<String, dynamic> soal, String jawabanKey) {
    final isSubmitted = _quizSubmitted;
    final isSelected = _selectedAnswers[soal['id']] == jawabanKey;
    final isCorrect = soal['kunci_jawaban'] == jawabanKey;

    Color backgroundColor;
    if (isSubmitted) {
      if (isCorrect) {
        backgroundColor = Colors.green; // Jawaban benar ditandai hijau
      } else if (isSelected) {
        backgroundColor =
            Colors.red; // Jawaban salah yang dipilih ditandai merah
      } else {
        backgroundColor = Colors.grey; // Jawaban lain abu-abu
      }
    } else {
      backgroundColor = isSelected
          ? Colors.blueGrey // Warna berbeda saat dipilih
          : Colors.green; // Warna default
    }

    return ElevatedButton(
      onPressed: isSubmitted
          ? null
          : () {
              _submitAnswer(soal['id'], jawabanKey);
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      child: Text(
        soal[jawabanKey].toString().toUpperCase(),
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  //konfimrasi
  void _showResultDialog(int score, int totalPoints) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hasil Kuis'),
          content: Text('Skor Anda: $score / $totalPoints'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pop(context); // Kembali ke halaman sebelumnya
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _pertanyaan = widget.kuis['pertanyaan'] ?? [];
    _durasi = _convertDuration(widget.kuis['durasi'] ?? '00:00:00');
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> pertanyaan = widget.kuis['pertanyaan'] ?? [];

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Kuis ${widget.kuis['judul_kuis']}',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Waktu Tersisa: ${_formatTime(_durasi)}',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pertanyaan.length,
                itemBuilder: (context, index) {
                  final soal = pertanyaan[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xff7A1FA0),
                      ),
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.greenAccent,
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Soal ${index + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            soal['pertanyaan'],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildPilihanJawaban(soal),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            if (!_quizSubmitted)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_userAnswers.length == _pertanyaan.length) {
                      _checkAnswers();
                    } else {
                      // Tampilkan peringatan jika belum semua pertanyaan terjawab
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Harap menjawab semua pertanyaan terlebih dahulu'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: Text(
                    'Kirim Jawaban',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoalCard(Map<String, dynamic> soal, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Soal ${index + 1}: ${soal['pertanyaan']}'),
          const SizedBox(height: 8),
          _buildPilihanJawaban(soal),
        ],
      ),
    );
  }

  Widget _buildPilihanJawaban(Map<String, dynamic> soal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildJawabanButton(soal, 'jawaban_a'),
        const SizedBox(height: 8),
        _buildJawabanButton(soal, 'jawaban_b'),
        const SizedBox(height: 8),
        _buildJawabanButton(soal, 'jawaban_c'),
        const SizedBox(height: 8),
        _buildJawabanButton(soal, 'jawaban_d'),
        const SizedBox(height: 8),
        _buildJawabanButton(soal, 'jawaban_e'),
      ],
    );
  }
}
