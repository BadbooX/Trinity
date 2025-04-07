import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class PageTitle extends StatelessWidget {
  final String text;
  final MainAxisAlignment mainAxisAlignment;

  const PageTitle(
      {super.key,
      required this.text,
      this.mainAxisAlignment = MainAxisAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 16),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 4),
        Icon(
          Symbols.dentistry,
          color: Color(0xffde2816),
          size: 24,
          weight: 600,
        ),
      ],
    );
  }
}
