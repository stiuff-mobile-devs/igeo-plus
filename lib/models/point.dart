import 'package:flutter/widgets.dart';
import 'dart:io';

class Point with ChangeNotifier {
  String? id;
  String? name;
  double? lat;
  double? long;
  String? date;
  String? time;
  String? description;
  int? user_id;
  String? project_id;
  bool isFavorite;
  List<String>? image;
  List<File>? pickedImages = [];

  Point({
    this.id,
    this.name,
    this.lat,
    this.long,
    this.date,
    this.time,
    this.description,
    this.user_id,
    this.project_id,
    this.isFavorite = false,
    this.image,
    this.pickedImages = const [],
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  void addUrlToImageList(String url) {
    image?.add(url);
  }

  void changeCoordinates(double lat, double long) {
    this.lat = lat;
    this.long = long;
    notifyListeners();
  }

  // Método toMap para conversão para formato de banco de dados
  Map<String, dynamic> toMap() {
    return {
      'project_id': project_id,
      'name': name,
      'date': date,
      'time': time,
      'lat': lat,
      'long': long,
      'description': description,
      'isFavorite': false
    };
  }

  factory Point.fromMap(String id, Map<String, dynamic> map) {
    return Point(
      id: id,
      user_id: int.tryParse(map["user_id"]?.toString() ?? '') ?? 0,
      project_id: map["project_id"]?.toString() ?? '',
      name: map["name"]?.toString() ?? 'Unnamed Point',
      lat: double.tryParse(map["lat"]?.toString() ?? '') ?? 0.0,
      long: double.tryParse(map["long"]?.toString() ?? '') ?? 0.0,
      date: map["date"]?.toString() ?? 'No date',
      time: map["time"]?.toString() ?? 'No time',
      description: map["description"]?.toString() ?? 'No description',
      image: map['images'] != null
          ? List<String>.from(map['images'])
          : <String>[],
      isFavorite: map['is_favorite'] ?? false,
    );
  }
}
