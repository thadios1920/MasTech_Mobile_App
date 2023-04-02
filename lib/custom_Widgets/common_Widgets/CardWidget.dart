import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  CardWidget({
    super.key,
    required this.titreProjet,
    required this.description,
    required this.date_limite,
  });
  final String titreProjet;
  final String description;
  final String date_limite;

  final colorwhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    // return Padding(
    //   padding: const EdgeInsets.only(top: 18.0),
    //   child: GridView.builder(
    //     itemCount: data.length,
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       // crossAxisSpacing: 10
    //     ),
    //     itemBuilder: (context, index) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: Colors.teal[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(padding: EdgeInsets.only(left: 1, bottom: 20)),
                  Text(
                    titreProjet,
                    style: TextStyle(
                        color: colorwhite,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      //color: Color.fromRGBO(0, 0, 0, 0.376)
                    ),
                    child: Icon(
                      Icons.business,
                      color: colorwhite,
                      size: 30,
                    ),
                  )
                ],
              ),
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, bottom: 20),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 10, color: colorwhite),
                  )),
              Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 10, bottom: 20)),
                      Text(
                        date_limite,
                        style: TextStyle(fontSize: 18, color: colorwhite),
                      ),
                      // Text(
                      //   '50-120',
                      //   style: TextStyle(fontSize: 18, color: colorwhite),
                      // ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
//       ),
//     );
//   }
// }
