class GeomorphClassification {
  String? id;
  String title;
  String? desc;
  bool isRoot;
  bool isPrimary;
  bool isSelected;
  List<GeomorphClassification> children;

  GeomorphClassification({
    this.id,
    required this.title,
    this.desc,
    this.isRoot = false,
    this.isPrimary = false,
    this.isSelected = false,
    this.children = const [],
  });

  bool get isLeaf => children.isEmpty;
}