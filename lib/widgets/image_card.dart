import 'dart:ui';

import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  String imgUrl;
  String credits;
  ImageCard({Key? key, required this.imgUrl, required this.credits})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Image.asset(imgUrl),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Image Credits : $credits',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
          ),
        )
      ],
    );
  }
}
