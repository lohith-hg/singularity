import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:singularity/constants/colors.dart';
import 'package:singularity/widgets/custom_button.dart';

class CustomDialog extends StatelessWidget {
  final String displayText;
  final String buttonText;
  final double buttonWidth;
  final Function onPressed;
  const CustomDialog(
      {Key? key,
      required this.displayText,
      required this.buttonText,
      required this.onPressed,
      this.buttonWidth = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: AlertDialog(
        backgroundColor: primaryColor,
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        content: Builder(
          builder: (context) {
            return SizedBox(
              height: 230,
              width: MediaQuery.of(context).size.width - 40,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, right: 20, left: 20),
                      child: Text(
                        displayText,
                        style: Theme.of(context).textTheme.headline1!.copyWith(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: Button(
                          width: buttonWidth,
                          height: 45,
                          backgroundColor: secondaryColor,
                          borderColor: secondaryColor,
                          textColor: Colors.white,
                          name: buttonText,
                          onTap: onPressed),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
