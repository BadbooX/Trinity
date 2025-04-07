import 'package:flutter/material.dart';

class MainActionnButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double fontSize;

  const MainActionnButton({
    super.key,
    required this.text,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(Size(120, 70)),
          maximumSize: WidgetStatePropertyAll(Size(160, 70)),
          backgroundColor: WidgetStateProperty.all(Color(0xFFDE2816)),
          padding: WidgetStateProperty.all(
              EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
          iconSize: WidgetStateProperty.all(24),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          )),
          iconColor: WidgetStateProperty.all(Colors.white)),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white, fontSize: fontSize),
                ),
              ],
            ),
    );
  }
}
