import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:hive/hive.dart'; // Importação necessária

// O build_runner usará isso para gerar o arquivo de persistência
part 'point.g.dart'; 

@HiveType(typeId: 0) // Define esta classe como um objeto do Hive
class Point extends HiveObject with ChangeNotifier {
    
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  double? lat;

  @HiveField(3)
  double? long;

  @HiveField(4)
  String? date;

  @HiveField(5)
  String? time;

  @HiveField(6)
  String? description;

  @HiveField(7)
  int? user_id;

  @HiveField(8)
  String? project_id;

  @HiveField(9)
  bool isFavorite;

  @HiveField(10)
  List<String>? image;

  // Nota: Campos como 'File' ou complexos que não devem ser salvos 
  // no banco local podem ficar sem a anotação @HiveField ou 
  // você pode criar um Adapter para eles. Por hora, vamos focar nos dados.
  List<File>? pickedImages = [];

  // Campo sugerido para a "Sincronização" citada nas atas
  @HiveField(11)
  bool isDirty; 

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
    this.isDirty = false, // Se for true, precisa subir pro Firebase
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    isDirty = true; // Marcar para sincronizar
    notifyListeners();
  }

  void addUrlToImageList(String url) {
    image?.add(url);
    isDirty = true;
  }

  void changeCoordinates(double lat, double long) {
    this.lat = lat;
    this.long = long;
    isDirty = true;
    notifyListeners();
  }

  // Mantemos o toMap e fromMap para o Firebase continuar funcionando
  Map<String, dynamic> toMap() {
    return {
      'project_id': project_id,
      'name': name,
      'date': date,
      'time': time,
      'lat': lat,
      'long': long,
      'description': description,
      'is_favorite': isFavorite
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
      isDirty: false, 
    );
  }
}
