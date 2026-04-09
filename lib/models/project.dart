import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 1)
class Project {

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

  @HiveField(5)
  DateTime? updatedAt;

  Project({
    this.id = "",
    required this.name,
    required this.createdAt,
    this.createdBy,
    this.isDirty = false,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt?.toIso8601String(),
      'is_dirty': isDirty,
    };
  }

  factory Project.fromMap(String id, Map<String, dynamic> map) {
    return Project(
      id: id,
      name: map['name']?.toString() ?? 'Sem nome',
      createdAt: map["created_at"] is Timestamp 
          ? (map["created_at"] as Timestamp).toDate() 
          : DateTime.parse(map["created_at"]?.toString() ?? DateTime.now().toIso8601String()),
      createdBy: map["created_by"]?.toString(),
      isDirty: false, 
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at'].toString()) 
          : DateTime.now(),
    );
  }
}