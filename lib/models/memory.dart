import 'dart:convert';

class Memory {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String imagePath;

  const Memory({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.imagePath,
  });

  Memory copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? imagePath,
  }) {
    return Memory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      imagePath: map['imagePath'] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Memory.fromJson(String source) =>
      Memory.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Memory(id: $id, title: $title, date: $date, imagePath: $imagePath)';
}
