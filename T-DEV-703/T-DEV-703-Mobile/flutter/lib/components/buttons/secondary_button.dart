import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final IconData? icon;
  final double fontSize;

  const SecondaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.icon,
      this.fontSize = 18});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          maximumSize: WidgetStatePropertyAll(Size(200, 50)),
          iconColor: WidgetStateProperty.all(Color(0xffde1628)),
          overlayColor: WidgetStateProperty.all(Color(0x10de1628)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 24,
              ),
            SizedBox(width: 6),
            Text(text,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    shadows: [
                      Shadow(color: Colors.black, offset: Offset(0, -5))
                    ],
                    color: Colors.transparent,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xffde1826),
                    decorationThickness: 4,
                    decorationStyle: TextDecorationStyle.solid,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize)),
          ],
        ));
  }
}
