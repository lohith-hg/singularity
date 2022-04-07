import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  String heading;
  String discription;
  ImageCard({Key? key, required this.heading, required this.discription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(heading,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(discription,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
        )
      ],
    );
  }
}
