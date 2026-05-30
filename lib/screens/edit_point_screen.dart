import 'package:flutter/material.dart';
import 'package:igeo/utils/routes.dart';
import '../data/geomorph_catalog.dart';
import '../models/point.dart';
import '../models/project.dart';
import '../utils/db_utils.dart';
import '../utils/fb_utils.dart';
import 'classification_selection_screen.dart';

class EditPointScreen extends StatefulWidget {
  const EditPointScreen({super.key});

  @override
  _EditPointScreenState createState() => _EditPointScreenState();
}

class _EditPointScreenState extends State<EditPointScreen> {
  late Point _originalPoint;
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _latController;
  late final TextEditingController _longController;
  List<List<String>> selectedClassifications = [];
  String? selectedDiscipline;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _latController = TextEditingController();
    _longController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArguments();
  }

  void _loadArguments() {
    if (_nameController.text.isEmpty) {
      final arguments = ModalRoute.of(context)!.settings.arguments as Map;
      _originalPoint = arguments["point"] as Point;
      _nameController.text = _originalPoint.name ?? '';
      _descriptionController.text = _originalPoint.description ?? '';
      _latController.text = _originalPoint.lat?.toStringAsFixed(6) ?? '';
      _longController.text = _originalPoint.long?.toStringAsFixed(6) ?? '';

      selectedClassifications =
      List<List<String>>.from(
        _originalPoint.geomorphClassification ?? [],
      );

      if (selectedClassifications.isNotEmpty) {
        selectedDiscipline = selectedClassifications.first.first;
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final updatedPoint = Point(
        id: _originalPoint.id,
        project_id: _originalPoint.project_id,
        name: _nameController.text,
        date: _originalPoint.date,
        time: _originalPoint.time,
        lat: double.tryParse(_latController.text),
        long: double.tryParse(_longController.text),
        description: _descriptionController.text,
        isFavorite: _originalPoint.isFavorite,
        image: _originalPoint.image,
        geomorphClassification: selectedClassifications
      );

      //await DbUtils.updatePoint(updatedPoint);
      await FirestoreUtils().updatePoint(updatedPoint);
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.HOME2,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit point', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF004D40),
        iconTheme: const IconThemeData(color: Colors.white),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.save, color: Colors.white),
        //     onPressed: _saveChanges,
        //   ),
        //   TextButton(
        //     onPressed: _saveChanges,
        //     child: const Text('OK',
        //         style: TextStyle(color: Colors.white, fontSize: 16)),
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Point Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _latController,
                decoration: InputDecoration(
                  labelText: 'Latitude',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required field';
                  final lat = double.tryParse(value);
                  if (lat == null) return 'Invalid number';
                  if (lat < -90 || lat > 90) return 'Between -90 and 90';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _longController,
                decoration: InputDecoration(
                  labelText: 'Longitude',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required field';
                  final long = double.tryParse(value);
                  if (long == null) return 'Invalid number';
                  if (long < -180 || long > 180) return 'Between -180 and 180';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedDiscipline,
                hint: const Text('Select a discipline'),
                decoration: InputDecoration(
                  labelText: 'Discipline',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                ),
                items: GeomorphologyCatalog.disciplines
                    .map(
                      (d) => DropdownMenuItem(
                    value: d[0].title,
                    child: Text(d[0].title),
                  ),
                )
                    .toList(),
                onChanged: (value) async {
                  if (value == null) return;

                  if (selectedDiscipline != null &&
                      selectedDiscipline != value) {
                    setState(() {
                      selectedClassifications.clear();
                    });
                  }

                  setState(() {
                    selectedDiscipline = value;
                  });
                },
              ),
              const SizedBox(height: 15),

              if (selectedDiscipline != null) ... [
                ElevatedButton(
                  onPressed: () async {
                    final discipline =
                    GeomorphologyCatalog.disciplines.firstWhere(
                          (e) => e[0].title == selectedDiscipline,
                    );

                    final path =
                    await Navigator.push<List<String>>(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ClassificationSelectorScreen(
                              node: discipline[0],
                              currentPath: [discipline[0].title],
                            ),
                      ),
                    );

                    if (path != null) {
                      setState(() {
                        addOrReplaceClassification(path);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text(
                    "Add geomorphological classification",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (selectedClassifications.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedClassifications.first.first,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF004D40),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...selectedClassifications.map(
                              (path) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              path.skip(1).join(" > "),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: Colors.red,
                              onPressed: () {
                                setState(() {
                                  selectedClassifications.remove(path);

                                  if (selectedClassifications.isEmpty) {
                                    selectedDiscipline = null;
                                  }
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF004D40),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void addOrReplaceClassification(List<String> newPath) {
    if (newPath.length < 2) return;

    final discipline = newPath[0];
    final type = newPath[1];

    if (selectedClassifications.isNotEmpty &&
        selectedClassifications.first[0] != discipline) {
      selectedClassifications.clear();
    }

    selectedClassifications.removeWhere(
          (path) =>
      path.length >= 2 &&
          path[0] == discipline &&
          path[1] == type,
    );

    selectedClassifications.add(newPath);
  }
}
