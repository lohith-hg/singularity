import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String name;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Function onTap;
  final double width;
  final double height;
  const Button(
      {Key? key,
      required this.backgroundColor,
      required this.borderColor,
      required this.textColor,
      required this.name,
      required this.onTap,
      this.width = 0.4,
      this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: () => onTap(),
      child: Container(
        height: height,
        width: MediaQuery.of(context).size.width * width,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: borderColor, width: 2)),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
