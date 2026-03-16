import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/point.dart';
import '../models/project.dart';
import 'auth_utils.dart';
import 'package:hive/hive.dart';
import 'dart:async';


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
      final user = auth.getFirebaseAuthUser();
      final docs = await _firestore
          .collection("projects")
          .where("created_by", isEqualTo: user?.id)
          .get()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('The connection to Firebase took too long.');
            },
          );

      List<Project> projects = docs.docs.map((e) => Project.fromMap(e.id, e.data())).toList();

      // Refatoração do Hive
      if (projects.isNotEmpty) {
        final projectBox = Hive.box<Project>('projects');
        await projectBox.putAll({for (var p in projects) p.id: p});
      }
      return projects;
    } catch (e) {
      debugPrint("Firebase error, trying Hive: $e");

      final projectBox = Hive.box<Project>('projects');
      return projectBox.values.toList();
    }
  }

  Future<List<Point>> getPointsByProject(String projectId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .get()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              throw TimeoutException('The connection to Firebase took too long.');
            },
          );
      final points = snapshot.docs
          .map((doc) => Point.fromMap(doc.id, doc.data()))
          .toList();

       // Refatoração do Hive
       if (points.isNotEmpty) {
        final pointBox = Hive.box<Point>('points');
        await pointBox.putAll({for (var p in points) p.id!: p}); 
       }

      return points;
      
    } catch (e) {
      debugPrint("Firebase error, trying Hive: $e");

      final pointBox = Hive.box<Point>('points');
      return pointBox.values.where((p) => p.project_id == projectId).toList();
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