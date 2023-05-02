import 'package:flutter/material.dart';

class TacheImage extends StatefulWidget {
  final String? imageURL;

  TacheImage({Key? key, required this.imageURL}) : super(key: key);

  @override
  _TacheImageState createState() => _TacheImageState();
}

class _TacheImageState extends State<TacheImage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: widget.imageURL != null && widget.imageURL!.isNotEmpty
                ? Image.network(
                    widget.imageURL!,
                    height: 400.0,
                    width: 300.0,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/placeHolder1.png', //chemin vers l'image de remplacement
                    height: 400.0,
                    width: 300.0,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ],
    );
  }
}
