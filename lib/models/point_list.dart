import 'package:flutter/widgets.dart';
import '../utils/db_utils.dart';
import 'point.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

class PointList with ChangeNotifier {
  List<Point> points = [];

  List<Point> get getPoints => points;

  List<Point> getPointsForProject(String projectId) {
    return points.where((point) => point.project_id == projectId).toList();
  }

  List<Point> get favoritePoints =>
      points.where((point) => point.isFavorite).toList();

  void addPoint(Point point) {
    points.add(point);
    notifyListeners();
  }

  void removePoint(String id) {
    points.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  Point getPoint(String pointId, String projectId) {
    return points
        .where((point) => point.id == pointId && point.project_id == projectId)
        .first;
  }

  void togglePointFavorite(String pointId, String projectId) {
    if (getPoint(pointId, projectId).isFavorite == false) {
      getPoint(pointId, projectId).isFavorite = true;
      DbUtils.favoritePoint(pointId, projectId);
    } else {
      getPoint(pointId, projectId).isFavorite = false;
      DbUtils.favoritePoint(pointId, projectId);
    }
    print(getPoint(pointId, projectId).isFavorite);
    notifyListeners();
  }

  void clear() {
    points = [];
    notifyListeners();
  }
  Future<void> syncPointsWithFirebase() async {
    final pointsBox = Hive.box<Point>('points');
    
    final dirtyPoints = pointsBox.values.where((p) => p.isDirty == true).toList();

    for (var point in dirtyPoints) {
      try {
        await FirebaseFirestore.instance
            .collection('points')
            .doc(point.id)
            .set(point.toMap());

        point.isDirty = false;
        await point.save(); 
        
        notifyListeners();
        print("Sincronizado: ${point.name}");
      } catch (e) {
        print("Erro na sincronização: $e");
      }
    }
  }
}
