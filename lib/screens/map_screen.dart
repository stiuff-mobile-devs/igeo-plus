import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialPosition;

  const MapScreen({required this.initialPosition});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedPosition;
  List<Polygon> _polygons = [];
  List<Marker> _geoMarkers = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJson();
  }

  Future<void> _loadGeoJson() async {
    try {
      final List<String> files = [
        'assets/map_data/Litologia_Mun_GeoCosteira.geojson',
        'assets/map_data/Pontos_Campo_GeoCosteira26.2.geojson',
        'assets/map_data/RecorteMunicípios_Campo_GeoCosteira26.2.geojson',
      ];

      List<Polygon> loadedPolygons = [];
      List<Marker> loadedMarkers = [];

      for (String file in files) {
        final String jsonString = await rootBundle.loadString(file);
        final data = jsonDecode(jsonString);
        final features = data['features'] as List;

        Color polyColor;
        Color borderColor;

        if (file.contains('Litologia')) {
          polyColor = Colors.orange.withOpacity(0.3);
          borderColor = Colors.orange;
        } else {
          polyColor = Colors.blue.withOpacity(0.3);
          borderColor = Colors.blue;
        }

        for (var feature in features) {
          if (feature['geometry'] == null) continue;
          
          final geomType = feature['geometry']['type'];

          if (geomType == 'MultiPolygon') {
            final multiPolygons = feature['geometry']['coordinates'] as List;
            for (var polygon in multiPolygons) {
              final outerRing = polygon[0] as List;
              List<LatLng> points = outerRing.map((point) {
                return LatLng(point[1].toDouble(), point[0].toDouble());
              }).toList();

              loadedPolygons.add(
                Polygon(
                  points: points,
                  isFilled: true,
                  color: polyColor,
                  borderColor: borderColor,
                  borderStrokeWidth: 2.0,
                ),
              );
            }
          } else if (geomType == 'Polygon') {
            final polygon = feature['geometry']['coordinates'] as List;
            final outerRing = polygon[0] as List;
            List<LatLng> points = outerRing.map((point) {
              return LatLng(point[1].toDouble(), point[0].toDouble());
            }).toList();

            loadedPolygons.add(
              Polygon(
                points: points,
                isFilled: true,
                color: polyColor,
                borderColor: borderColor,
                borderStrokeWidth: 2.0,
              ),
            );
          } else if (geomType == 'Point') {
            final coords = feature['geometry']['coordinates'] as List;
            final point = LatLng(coords[1].toDouble(), coords[0].toDouble());

            loadedMarkers.add(
              Marker(
                point: point,
                builder: (ctx) => const Icon(
                  Icons.circle,
                  color: Colors.red,
                  size: 16,
                ),
              ),
            );
          }
        }
      }

      setState(() {
        _polygons = loadedPolygons;
        _geoMarkers = loadedMarkers;
      });
    } catch (e) {
      debugPrint("Error loading GeoJSON: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select...',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(
                context, _selectedPosition ?? widget.initialPosition),
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: widget.initialPosition,
          zoom: 13,
          onTap: (tapPosition, latLng) {
            setState(() => _selectedPosition = latLng);
          },
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            userAgentPackageName: 'com.example.app',
          ),
          PolygonLayer(
            polygons: _polygons,
          ),
          MarkerLayer(
            markers: [
              ..._geoMarkers,
              if (_selectedPosition != null)
                Marker(
                  point: _selectedPosition!,
                  builder: (ctx) => const Icon(
                    Icons.location_pin,
                    color: Colors.amber,
                    size: 40,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
