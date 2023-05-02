import 'package:flutter/material.dart';

class MyImageEditor extends StatefulWidget {
  @override
  _MyImageEditorState createState() => _MyImageEditorState();
}

class _MyImageEditorState extends State<MyImageEditor> {
  List<Rect> boxes = [
    Rect.fromLTWH(0.1, 0.2, 0.1, 0.2),
    Rect.fromLTWH(0.3, 0.5, 0.05, 0.4),
  ]; // Liste des positions des boîtes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editeur d'image"),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return AspectRatio(
            aspectRatio: 16 / 9,
            child: Stack(
              children: [
                Image.network(
                  "http://192.168.1.12:8080/public/uploads/plan-maison-Basque-170m2-rdc.jpg-1679264639192.jpeg",
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
                ...boxes.map((box) {
                  return Positioned(
                    left: box.left * constraints.maxWidth,
                    top: box.top * constraints.maxHeight,
                    width: box.width * constraints.maxWidth,
                    height: box.height * constraints.maxHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
