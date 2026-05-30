import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:igeo/models/geomorphic_classification.dart';

class ClassificationSelectorScreen extends StatelessWidget {
  final GeomorphClassification node;
  final List<String> currentPath;

  const ClassificationSelectorScreen({
    super.key,
    required this.node,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          node.title,
          style: const TextStyle(color: Colors.white),),
      ),
      body: ListView.builder(
        itemCount: node.children.length,
        itemBuilder: (context, index) {
          final child = node.children[index];

          return ListTile(
            title: Text(child.title),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final newPath = [...currentPath, child.title];

              if (child.isLeaf) {
                Navigator.pop(context, newPath);
                return;
              }

              final result =
              await Navigator.push<List<String>>(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ClassificationSelectorScreen(
                        node: child,
                        currentPath: newPath,
                      ),
                ),
              );

              if (result != null) {
                Navigator.pop(context, result);
              }
            },
          );
        },
      ),
    );
  }
}