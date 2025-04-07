import 'package:flutter/material.dart';

class AnonymPagesLayout extends StatelessWidget {
  final Widget child;

  const AnonymPagesLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [
          Positioned(
            bottom: -320,
            left: -100,
            height: MediaQuery.of(context).size.height * 0.8,
            width: 500,
            child: Transform.rotate(
              angle: -0.99,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.black, Colors.transparent],
                    stops: [0.5, 1.0],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/background-gingham.webp',
                  width: 250,
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -160,
            left: -100,
            child: Image(
              image: AssetImage('assets/images/background-food.png'),
              height: MediaQuery.of(context).size.height * 0.55,
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        ]));
  }
}
