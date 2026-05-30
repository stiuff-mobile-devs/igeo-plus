import 'package:flutter/material.dart';
import 'package:igeo/data/geomorph_catalog.dart';
import '../components/image_input.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../models/point.dart';
import '../models/project.dart';
import '../components/location_input.dart';
import 'package:hive/hive.dart';

import 'classification_selection_screen.dart';

class NewPointFormScreen extends StatefulWidget {
  @override
  State<NewPointFormScreen> createState() => _NewPointFormScreenState();
}

class _NewPointFormScreenState extends State<NewPointFormScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedDiscipline;
  List<List<String>> selectedClassifications = [];
  List<File> pickedImages = [];

  void addImage(File pickedImage) {
    if (pickedImages.length >= 4) return;
    pickedImages.add(pickedImage);
  }

  void sendBackData(BuildContext context, Project project) async {
    final pointProvider = Provider.of<PointProvider>(context, listen: false);

    // if (pointProvider.lat == null || pointProvider.long == null) {
    //   showDialog(
    //     context: context,
    //     builder: (ctx) => AlertDialog(
    //       title: const Text('Missing Location'),
    //       content: const Text('Please select a location before submitting'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(ctx),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    //   return;
    // }
    if (_nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Required point name'),
          content: const Text('Please enter a name for the point'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final newPoint = Point(
      name: _nameController.text,
      description: _descriptionController.text,
      lat: pointProvider.lat,
      long: pointProvider.long,
      date: DateFormat("d/M/yyyy").format(DateTime.now()),
      time: DateTime.now().toString().substring(10, 19),
      user_id: 1,
      project_id: project.id,
      pickedImages: pickedImages,
      geomorphClassification: selectedClassifications,
    );

    final pointsBox = Hive.box<Point>('points');
    await pointsBox.add(newPoint);

    Navigator.pop(context, newPoint);
  }

  @override
  Widget build(BuildContext context) {
    final project = ModalRoute.of(context)!.settings.arguments as Project;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PointProvider()),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            children: [
              const Icon(Icons.gps_fixed, color: Colors.white),
              Text(
                "New point in ${project.name}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: Consumer<PointProvider>(
              builder: (context, pointProvider, child) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Point name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.black12,
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a point name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Point description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        filled: true,
                        fillColor: Colors.black12,
                      ),
                      maxLines: 6,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    disciplineSelector(),
                    const SizedBox(height: 20),
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
                    // Column(
                    //   children: selectedClassifications.map((path) {
                    //     return Card(
                    //       child: ListTile(
                    //         title: Text(path.skip(1).join(" > ")),
                    //         trailing: IconButton(
                    //           icon: const Icon(Icons.remove_circle_outline),
                    //           color: Colors.red,
                    //           onPressed: () {
                    //             setState(() {
                    //               selectedClassifications.remove(path);
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    // ),
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
                    LocationInput(),
                    ImageInput(addImage),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => sendBackData(context, project),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget disciplineSelector() {
    return DropdownButtonFormField<String>(
      hint: const Text('Select a discipline'),
      decoration: InputDecoration(
        labelText: 'Discipline',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.black12,
      ),
      value: selectedDiscipline,
      items: GeomorphologyCatalog.disciplines
          .map(
            (d) => DropdownMenuItem(
          value: d[0].title,
          child: Text(d[0].title),
        ),
      )
          .toList(),
      onChanged: (value) async {
        // if (value == null) return;
        if (selectedDiscipline != null &&
            selectedDiscipline != value) {
          setState(() {
            selectedClassifications.clear();
          });
        }

        setState(() {
          selectedDiscipline = value;
        });

        // final discipline =
        // GeomorphologyCatalog.disciplines.firstWhere(
        //       (d) => d[0].title == value,
        // );
        //
        // final path = await Navigator.push<List<String>>(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => ClassificationSelectorScreen(
        //       node: discipline[0],
        //       currentPath: [discipline[0].title],
        //     ),
        //   ),
        // );
        //
        // if (path != null) {
        //   setState(() {
        //     addOrReplaceClassification(path);
        //   });
        // }
      },
    );
  }

  void addOrReplaceClassification(List<String> newPath) {
    final discipline = newPath[0];
    final classificationType = newPath[1];

    selectedClassifications.removeWhere(
          (path) =>
      path[0] == discipline &&
          path[1] == classificationType,
    );

    selectedClassifications.add(newPath);
  }
}
