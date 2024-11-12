class MaterialModel {
  final int id;
  final String title;
  final String description;
  final String filePath;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.filePath,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      title: json['judul'] ?? '',
      description: json['deskripsi'] ?? '',
      filePath: json['file_path'] ?? '',
    );
  }
}

class BabIndex {
  final List<Bab> data;

  BabIndex({required this.data});

  factory BabIndex.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Bab> babList = list.map((i) => Bab.fromJson(i)).toList();
    return BabIndex(data: babList);
  }
}

class Bab {
  final int id;
  final String judul;
  final String deskripsi;

  Bab({required this.id, required this.judul, required this.deskripsi});

  factory Bab.fromJson(Map<String, dynamic> json) {
    return Bab(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
    );
  }
}
