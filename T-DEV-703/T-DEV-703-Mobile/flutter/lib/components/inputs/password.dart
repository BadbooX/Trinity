import 'package:bite/validators/password.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const PasswordInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  PasswordInputState createState() => PasswordInputState();
}

class PasswordInputState extends State<PasswordInput> {
  String? passwordError;

  // Password validation logic
  void _validatePassword() {
    final passwordText = widget.controller.text;
    if (passwordText.isEmpty) {
      passwordError = 'Please enter a password';
    } else if (!isValidPassword(passwordText)) {
      // Contains at least one digit.
      // Contains at least one lowercase letter.
      // Contains at least one uppercase letter.
      // Is at least 8 characters long.
      passwordError =
          'Password must contain at least one digit, \none lowercase letter, \none uppercase letter, \nand be at least 8 characters long';
    } else {
      passwordError = null; // No error means the input is OK
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.lock_outline,
                color: Color(0xffde2816),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Password',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextField(
            controller: widget.controller,
            obscureText: true,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFE8B3B8)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              constraints: BoxConstraints(maxHeight: 62, maxWidth: 300),
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
              _validatePassword();
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
