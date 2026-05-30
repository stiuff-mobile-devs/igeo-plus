import 'package:igeo/data/geomorfologia_costeira.dart';
import 'package:igeo/models/geomorphic_classification.dart';

class GeomorphologyCatalog {
  static List<List<GeomorphClassification>> disciplines = [
    GeomorfologiaCosteira.tree,
  ];
}