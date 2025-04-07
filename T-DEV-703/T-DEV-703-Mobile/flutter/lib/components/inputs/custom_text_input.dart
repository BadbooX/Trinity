import 'dart:core';

import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final String? placeholder;
  final TextEditingController controller;
  final Function(String) onChanged;
  final IconData? icon;

  const CustomTextInput({
    super.key,
    required this.label,
    this.placeholder,
    required this.controller,
    required this.onChanged,
    required this.icon,
  });

  @override
  CustomTextInputState createState() => CustomTextInputState();
}

class CustomTextInputState extends State<CustomTextInput> {
  String? error;

  void _validateInput() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      error = 'Please enter ';
    } else {
      error = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                widget.icon,
                color: Color(0xffde2816),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.text,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE8B3B8)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              constraints: BoxConstraints(maxHeight: 62, maxWidth: 300),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.w600,
                backgroundColor: Colors.white,
              ),
              fillColor: Color(0xFFE8B3B8),
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffde2816)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: const Color.fromARGB(255, 185, 35, 35)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: const Color(0xffde2816)),
              ),
              focusColor: Color.fromARGB(255, 235, 177, 183),
            ),
            onChanged: (value) {
              _validateInput();
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
