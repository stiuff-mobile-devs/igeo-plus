import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/point.dart';
import '../models/project.dart';
import '../utils/routes.dart';

class ProjectMapScreen extends StatefulWidget {
  final List<Point> points;
  final Project project;

  const ProjectMapScreen({
    super.key,
    required this.points,
    required this.project
  });

  @override
  State<ProjectMapScreen> createState() => _ProjectMapScreenState();
}

class _ProjectMapScreenState extends State<ProjectMapScreen> {

  late final List<LatLng> latLngPoints;

  @override
  void initState() {
    super.initState();

    latLngPoints = widget.points
        .map((p) => LatLng(p.lat!, p.long!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (latLngPoints.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mapa do Projeto", style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(child: Text("Nenhum ponto disponível")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa do Projeto", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _calculateCenter(latLngPoints),
          zoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: widget.points.map((point) {
              final latLng = LatLng(point.lat!, point.long!);

              return Marker(
                point: latLng,
                width: 40,
                height: 40,
                builder: (_) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAILS,
                        arguments: {"project": widget.project, "point": point});
                  },
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  LatLng _calculateCenter(List<LatLng> points) {
    double lat = 0;
    double lng = 0;

    for (var p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }

    return LatLng(lat / points.length, lng / points.length);
  }
}
