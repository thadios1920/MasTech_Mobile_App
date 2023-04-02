import 'package:flutter/material.dart';

class TacheImage extends StatefulWidget {
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
            child: FadeInImage(
              placeholder: AssetImage('assets/images/user6.jpg'),
              image: NetworkImage(
                  'https://images.freeimages.com/images/previews/ac9/railway-hdr-1361893.jpg'),
              fit: BoxFit.cover,
              imageErrorBuilder:
                  (BuildContext context, Object exception, stackTrace) {
                // En cas d'erreur lors de la récupération de l'image depuis l'URL, afficher l'image de l'asset
                return Image.asset('assets/images/user6.jpg',
                    fit: BoxFit.cover);
              },
            ),
          ),
        )
      ],
    );
  }
}
