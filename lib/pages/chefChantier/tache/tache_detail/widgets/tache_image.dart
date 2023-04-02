import 'package:flutter/material.dart';

class TacheImage extends StatefulWidget {
  @override
  _TacheImageState createState() => _TacheImageState();
}

class _TacheImageState extends State<TacheImage> {
  String image = "s";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
              margin: EdgeInsets.symmetric(
                vertical: 20.0,
              ),
              height: 200.0,
              child: Image.network(
                'https://images.freeimages.com/images/previews/ac9/railway-hdr-1361893.jpg',
                height: 80.0,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  if (image == "") {
                    return Center(
                      child: Text("Pas d'image."),
                    );
                  }
                  return Center(
                    child: Text("Échec du chargement de l'image."),
                  );
                },
              )),
        )
      ],
    );
  }
}
