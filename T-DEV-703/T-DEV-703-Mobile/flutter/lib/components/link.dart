import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String text;
  final String route;
  final bool isExternal;
  final int fontSize;

  const Link(
      {super.key,
      required this.text,
      required this.route,
      this.fontSize = 16,
      required this.isExternal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isExternal) {
          router.go((route));
        } else {
          router.go('/$route');
        }
      },
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: Color(0xffde2816), fontWeight: FontWeight.w600),
      ),
    );
  }
}
