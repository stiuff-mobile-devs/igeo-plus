import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String name;
  DateTime createdAt;

  Project({
    this.id = "",
    required this.name,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'created_at': createdAt,
    };
  }

  factory Project.fromMap(String id, Map<String, dynamic> map) {
    return Project(
      id: id,
      name: map['name'],
      createdAt: (map["created_at"] as Timestamp).toDate(),
    );
  }
}
