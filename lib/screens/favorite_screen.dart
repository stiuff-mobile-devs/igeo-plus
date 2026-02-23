import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/point.dart';
import '../components/point_item_favorite.dart';
import '../utils/fb_utils.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FirestoreUtils _firestore = FirestoreUtils();
  List<Point> favoritePoints = [];
  List<Project> projects = [];
  bool loading = true;

  // bool _toBoolean(dynamic value) {
  //   if (value is bool) return value;
  //   if (value is String) return value.toLowerCase() == 'true';
  //   if (value is int) return value == 1;
  //   return false;
  // }

  Future<void> _getPoints() async {
    projects = await _firestore.getAllProjects();
    List<Point> allPoints = [];
    for (Project p in projects) {
      final pointsData = await _firestore.getPointsByProject(p.id);
      allPoints.addAll(pointsData);
    }
    setState(() {
      favoritePoints = allPoints.where((p) => p.isFavorite).toList();
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getPoints();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.amber,
        ),
      );
    }

    return Scaffold(
      body: favoritePoints.isNotEmpty
      ? ListView.builder(
          itemCount: favoritePoints.length,
          itemBuilder: (ctx, index) => PointItemFavorite(
            favoritePoints[index],
            projects,
          ),
      )
      : const Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gps_off, color: Colors.amber),
            SizedBox(width: 5),
            Text('No favorite points added yet',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
    );
  }
}
