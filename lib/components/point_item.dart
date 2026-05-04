import 'package:flutter/material.dart';

import '../models/point.dart';
import '../models/project.dart';

import '../utils/fb_utils.dart';
import '../utils/routes.dart';

class PointItem extends StatefulWidget {
  final Point point;
  final Project project;
  //final Map<String, dynamic> userData;
  // final Function(int, String, int) onDeletePoint;
  final Function(String) onDeletePoint;
  final void Function(String, String, bool) onToggleFavorite;
  final bool isFavorite;

  const PointItem(
    this.point,
    this.project,
    //this.userData,
    this.onDeletePoint,
    this.onToggleFavorite,
    this.isFavorite,
  );

  @override
  State<PointItem> createState() => _PointItemState();
}

class _PointItemState extends State<PointItem> {
  final FirestoreUtils firestore = FirestoreUtils();
  bool isFavorite = false;
  void _goToPointDetailsScreen(
      BuildContext context, Project project, Point point) {
    Navigator.of(context).pushNamed(AppRoutes.POINT_DETAILS,
        arguments: {"project": project, "point": point});
  }

  @override
  void initState() {
    super.initState();
    isFavorite = widget.point.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          _goToPointDetailsScreen(context, widget.project, widget.point),
      splashColor: Colors.amber,
      hoverColor: const Color.fromARGB(255, 181, 220, 238),
      child: Dismissible(
        key: ValueKey(widget.point.id),
        confirmDismiss: (direction) async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Excluir ponto'),
              content: const Text('Tem certeza que deseja excluir este ponto?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Excluir'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            await firestore.deletePoint(widget.point);
            return true;
          }

          return false;
        },
        direction: DismissDirection.horizontal,
        background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
        ),
        child: ListTile(
          leading: const FittedBox(
            fit: BoxFit.fitWidth,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: const Icon(
                Icons.gps_fixed_outlined,
                color: Colors.white,
              ),
            ),
          ),
          title: Text(widget.point.name!),
          subtitle: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.gps_fixed_sharp,
                  size: 13,
                  color: Color.fromARGB(255, 7, 163, 221),
                ),
              ),
              widget.point.lat != 0
                  ? Text(
                      "Lat: ${widget.point.lat?.toStringAsFixed(2)} - Lon: ${widget.point.long?.toStringAsFixed(2)}")
                  : Text("No location"),
              const SizedBox(width: 3),
              // Container(
              //   margin: const EdgeInsets.only(right: 2),
              //   child: const Icon(
              //     Icons.calendar_month,
              //     size: 13,
              //     color: Color.fromARGB(255, 7, 163, 221),
              //   ),
              // ),
              // Text(widget.point.date!)
            ],
          ),
          trailing: IconButton(
            icon: isFavorite == true
                ? const Icon(
                    Icons.star,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.star_outline,
                    color: Colors.amber,
                  ),
            onPressed: () {
              widget.onToggleFavorite(widget.point.id!, widget.project.id, !isFavorite);
              setState(() {
                //print("ESTADO: " + isFavorite.toString());

                isFavorite = !isFavorite;
              });
              // favoritePoint(
              //   widget.userData["id"],
              //   widget.userData["token"],
              //   widget.point.id!,
              // );
            },
          ),
        ),
      ),
    );
  }
}
