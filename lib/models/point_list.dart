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
        point.updatedAt = DateTime.now();
        
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
  Future<void> loadPointsFromFirebase() async {
    final pointsBox = Hive.box<Point>('points');
    
    try {
      // 1. Para buscar os pontos da nuvem
      final snapshot = await FirebaseFirestore.instance.collection('points').get();

      for (var doc in snapshot.docs) {
        // Criamos o objeto vindo da nuvem (ele nasce com isDirty = false no fromMap)
        Point remotePoint = Point.fromMap(doc.id, doc.data());
        
        // Tentamos achar esse mesmo ponto no seu celular (Hive)
        Point? localPoint = pointsBox.get(doc.id);

        // ATIVIDADE 1: Lógica de Comparação (Timestamp)
        // Se o ponto não existe no celular OU se a versão da nuvem for mais nova
        bool isRemoteNewer = localPoint == null || 
            (remotePoint.updatedAt != null && localPoint.updatedAt == null) ||
            (remotePoint.updatedAt != null && localPoint.updatedAt != null && 
             remotePoint.updatedAt!.isAfter(localPoint.updatedAt!));

        if (isRemoteNewer) {
          // ATIVIDADE 2: Salva no Hive. 
          // O isDirty já vai como FALSE aqui porque veio do fromMap.
          await pointsBox.put(doc.id, remotePoint);
          print("Ponto ${remotePoint.name} atualizado da nuvem.");
        }
      }
      
      // Atualiza a lista da memória com o que está no Hive agora
      points = pointsBox.values.toList();
      notifyListeners();
      
    } catch (e) {
      print("Erro ao carregar do Firebase: $e");
    }
  } // Chave final da classe
}
