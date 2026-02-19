import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String name;
  DateTime createdAt;
  String? createdBy;

  Project({
    this.id = "",
    required this.name,
    required this.createdAt,
    this.createdBy
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'created_at': createdAt,
      'created_by': createdBy
    };
  }

  factory Project.fromMap(String id, Map<String, dynamic> map) {
    return Project(
      id: id,
      name: map['name'],
      createdAt: (map["created_at"] as Timestamp).toDate(),
      createdBy: map["created_by"]
    );
  }
}
