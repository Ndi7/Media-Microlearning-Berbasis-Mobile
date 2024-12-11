class Materi {
  final int id;
  final String judul;
  final String userName;
  final String judulBab;

  Materi({
    required this.id,
    required this.judul,
    required this.userName,
    required this.judulBab,
  });

  // Factory method untuk parsing dari JSON
  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      id: json['id'],
      judul: json['judul'],
      userName: json['user_name'],
      judulBab: json['judul_bab'],
    );
  }
}
