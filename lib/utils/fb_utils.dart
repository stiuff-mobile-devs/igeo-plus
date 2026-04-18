import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:igeo/utils/db_utils.dart';
import '../models/point.dart';
import '../models/project.dart';
import 'auth_utils.dart';
import 'package:hive/hive.dart';

class FirestoreUtils {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthUtils auth = AuthUtils();
  final Box<Point> _pointsBox = Hive.box<Point>("points");
  final Box<Project> _projectsBox = Hive.box<Project>("projects");

  Future<Project?> createProject(Project project) async {
    try {
      final user = auth.getFirebaseAuthUser();
      project.createdBy = user?.id;
      await _firestore
          .collection("projects")
          .doc(project.id)
          .set(project.toMap())
          .timeout(const Duration(seconds: 2));
      project.isDirty = false;
      _projectsBox.put(project.id, project);
    } catch (e) {
      debugPrint("Error on create project: $e");
      _projectsBox.put(project.id, project);
    }
    return project;
  }

  Future<void> createPoint(Point pointData) async {
    _pointsBox.put(pointData.id, pointData);

    try {
      await _firestore
          .collection('projects')
          .doc(pointData.project_id)
          .collection('points')
          .doc(pointData.id)
          .set(pointData.toMap())
          .timeout(const Duration(seconds: 1));

      pointData.isDirty = false;
      _pointsBox.put(pointData.id, pointData);
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
          .timeout(const Duration(seconds: 1));

      List<Project> projects = docs.docs.map((e) => Project.fromMap(e.id, e.data())).toList();

      // Refatoração do Hive
      if (projects.isNotEmpty) {
        await _projectsBox.putAll({for (var p in projects) p.id: p});
      }
      return projects;
    } catch (e) {
      debugPrint("Firebase error, trying Hive: $e");
      return _projectsBox.values.toList();
    }
  }

  Future<List<Point>> getPointsByProject(String projectId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .get()
          .timeout(const Duration(seconds: 1));

      final points = snapshot.docs
          .map((doc) => Point.fromMap(doc.id, doc.data()))
          .toList();

       // Refatoração do Hive
       if (points.isNotEmpty) {
        await _pointsBox.putAll({for (var p in points) p.id!: p});
       }

      return points;
    } catch (e) {
      debugPrint("Firebase error, trying Hive: $e");
      final list = _pointsBox.values.where((p) => p.project_id == projectId && p.id != null).toList();
      debugPrint("DATA LENGTH: ${list.length}");
      return list;
    }
  }

  Future<Point?> getPoint(String projectId, String pointId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .doc(pointId)
          .get()
          .timeout(const Duration(seconds: 1));

      if (!doc.exists) return null;
      Point p = Point.fromMap(doc.id, doc.data()!);
      _pointsBox.put(p.id,p);
      return p;
    } catch (e) {
      debugPrint("Error on get point: $e");
      return _pointsBox.values.firstWhere((p) => p.id == pointId);
    }
  }

  Future<void> updateFavorite(String pointId, String projectId, bool status) async {
    Point p = _pointsBox.values.firstWhere((p) => p.id == pointId);
    p.isFavorite = status;
    p.isDirty = true;
    _pointsBox.put(p.id,p);

    try {
      await _firestore
          .collection('projects')
          .doc(projectId)
          .collection('points')
          .doc(pointId)
          .update({'is_favorite': status})
          .timeout(const Duration(seconds: 1));
      p.isDirty = false;
      _pointsBox.put(p.id,p);
    } catch (e) {
      debugPrint("Error on save favorite on firestore: $e");
    }
  }

  Future<void> updatePoint(Point point) async {
    point.isDirty = true;
    _pointsBox.put(point.id,point);

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
          .update(point.toMap())
          .timeout(const Duration(seconds: 1));
      point.isDirty = false;
      _pointsBox.put(point.id,point);
    } catch (e) {
      debugPrint("Error on update point firestore: $e");
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
      _pointsBox.delete(point.id);
    } catch (e) {
      debugPrint("Error on delete point ${point.id}: $e.");
      throw Exception("Erro ao excluir ponto.");
    }
  }

  editProject(String id, String newName) async {
    Project p = _projectsBox.values.firstWhere((p) => p.id == id);
    p.name = newName;
    p.isDirty = true;
    _projectsBox.put(p.id,p);

    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(id)
          .update({
        'name': newName,
      })
          .timeout(const Duration(seconds: 1));

      p.isDirty = false;
      _projectsBox.put(p.id,p);
    } catch (e) {
      debugPrint("Error on edit project $id: $e.");
      //throw Exception("Erro ao editar projeto.");
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      final ref =
          FirebaseFirestore.instance.collection('projects').doc(projectId);

      final points = await ref.collection('points').get();

      for (var doc in points.docs) {
        _pointsBox.delete(doc.id);
        await doc.reference.delete();
      }

      await ref.delete();
      _projectsBox.delete(projectId);
    } catch (e) {
      debugPrint("error on delete project: $e");
    }
  }

  Future<void> synchronize() async {
    try {
      final dirtyProjects =
          _projectsBox.values.where((project) => project.isDirty).toList();

      for (Project p in dirtyProjects) {
        await createProject(p);
      }

      final dirtyPoints =
          _pointsBox.values.where((point) => point.isDirty).toList();

      for (Point p in dirtyPoints) {
        await createPoint(p);
      }
    } catch (e){
      debugPrint("error on firestore sync: $e");
    }
  }

  //////////////////////////////////////

  Future<String?> downloadData() async {
    List<Project> projects = await getAllProjects();
    List<Point> points = [];

    for (Project p in projects) {
      points.addAll(await getPointsByProject(p.id));
    }

    List<Map<String, dynamic>> result = points.map((p) => p.toMapCsv()).toList();

    try {
      // final List<Map<String, dynamic>> result = await db.rawQuery(
      //     'SELECT p.long, p.lat, p.id, p.name, p.description, p.date, p.time, s.project_name '
      //         'FROM points AS p '
      //         'JOIN projects AS s ON p.project_id = s.id');

      if (result.isEmpty) return null;

      final csvData = [
        [
          "long",
          "lat",
          "id",
          "name",
          "description",
          "date",
          "time",
          "project_id"
        ],
        ...result.map((e) => [
          e["long"],
          e["lat"],
          e["id"],
          e["name"],
          e["description"],
          e["date"],
          e["time"],
          e["project_id"]
        ])
      ];

      return await DbUtils.generateCsv(csvData);
    } finally {
      //await db.close();
    }
  }
}