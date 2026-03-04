import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/point.dart';
import '../models/project.dart';
import 'auth_utils.dart';

class FirestoreUtils {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthUtils auth = AuthUtils();

  Future<Project?> createProject(Project project) async {
    try {
    final user = auth.getFirebaseAuthUser();
    project.createdBy = user?.id;
    final docRef = await _firestore.collection("projects").add(project.toMap());
    project.id = docRef.id;
    return project;
    } catch (e) {
      debugPrint("Error on create project: $e");
      return null;
    }
  }

  Future<void> createPoint(Map<String, dynamic> pointData) async {
    try {
      await _firestore
          .collection('projects')
          .doc(pointData['project_id'])
          .collection('points')
          .add(pointData);
    } catch (e) {
      debugPrint("Error on create point: $e");
    }
  }

  Future<List<Project>> getAllProjects() async {
    try {
      List<Project> projects = [];
      final user = auth.getFirebaseAuthUser();
      final docs = await _firestore
          .collection("projects")
          .where("created_by", isEqualTo: user?.id)
          .get();
      projects = docs.docs.map((e) => Project.fromMap(e.id, e.data())).toList();
      return projects;
    } catch (e) {
      debugPrint("Error on list all projects: $e");
      return [];
    }
  }

  Future<List<Point>> getPointsByProject(String projectId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .get();

      return snapshot.docs
          .map((doc) => Point.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      debugPrint("Error on get all points from project: $e");
      return [];
    }
  }

  Future<Point?> getPoint(String projectId, String pointId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .doc(pointId)
          .get();

      if (!doc.exists) return null;
      return Point.fromMap(doc.id, doc.data()!);
    } catch (e) {
      debugPrint("Error on get point: $e");
      return null;
    }
  }

  Future<void> updateFavorite(String pointId, String projectId, bool status) async {
    await _firestore
        .collection('projects')
        .doc(projectId)
        .collection('points')
        .doc(pointId)
        .update({'is_favorite': status});
  }

  Future<void> updatePoint(Point point) async {
    try {
      if (point.project_id == null || point.id == null) {
        debugPrint("Error: point.id or project_id is null");
        return;
      }

      await _firestore
          .collection('projects')
          .doc(point.project_id!)
          .collection('points')
          .doc(point.id!)
          .update(point.toMap());
    } catch (e) {
      debugPrint("Error on update point: $e");
    }
  }

  deletePoint(Point point) async {
    try {
      _firestore
          .collection('projects')
          .doc(point.project_id)
          .collection('points')
          .doc(point.id)
          .delete();
    } catch (e) {
      debugPrint("Error on delete point ${point.id}: $e.");
      throw Exception("Erro ao excluir ponto.");
    }
  }

  editProject(String id, String newName) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(id)
          .update({
        'name': newName,
      });
    } catch (e) {
      debugPrint("Error on edit project $id: $e.");
      throw Exception("Erro ao editar projeto.");
    }
  }

  Future<void> deleteProject(String projectId) async {
    final ref =
    FirebaseFirestore.instance.collection('projects').doc(projectId);

    final points = await ref.collection('points').get();

    for (var doc in points.docs) {
      await doc.reference.delete();
    }

    await ref.delete();
  }
}