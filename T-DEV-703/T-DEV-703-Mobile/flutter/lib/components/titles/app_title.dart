import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  final int fontSize;
  final int imgSize;
  final MainAxisAlignment alignment;

  const AppTitle(
      {super.key,
      required this.fontSize,
      required this.imgSize,
      this.alignment = MainAxisAlignment.center});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        Image(
          image: AssetImage('assets/images/logo.png'),
          width: imgSize.toDouble(),
        ),
        SizedBox(width: 6),
        Text(
          'bite.',
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                fontSize: fontSize.toDouble(),
              ),
        ),
      ],
    );
  }
}
