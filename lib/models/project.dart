import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 1)
class Project extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String? createdBy;

  @HiveField(4)
  bool isDirty;

  Project({
    required this.id,
    required this.name,
    required this.createdAt,
    this.createdBy,
    required this.isDirty
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
      createdBy: map["created_by"],
      isDirty: false
    );
  }
}
