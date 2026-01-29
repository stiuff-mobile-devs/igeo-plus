import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/project.dart';

class FirestoreUtils {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Project?> createProject(Project project) async {
    try {
    final docRef = await _firestore.collection("projects").add(project.toMap());
    project.id = docRef.id;
    return project;
    } catch (e) {
      debugPrint("Error on create project: $e");
      return null;
    }
  }

  Future<List<Project>> getAllProjects() async {
    try {
      List<Project> projects = [];
      final docs = await _firestore.collection("projects").get();
      projects = docs.docs.map((e) => Project.fromMap(e.id, e.data())).toList();
      return projects;
    } catch (e) {
      debugPrint("Error on list all projects: $e");
      return [];
    }
  }
}