import 'package:flutter/material.dart';

import 'package:bite/validators/email.dart';

class EmailInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const EmailInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  EmailInputState createState() => EmailInputState();
}

class EmailInputState extends State<EmailInput> {
  String? emailError;

  // Email validation logic
  void _validateEmail() {
    final emailText = widget.controller.text;
    if (emailText.isEmpty) {
      emailError = 'Please enter an email';
    } else if (!isValidEmail(emailText)) {
      emailError = 'Please enter a valid email';
    } else {
      emailError = null; // No error means the input is OK
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
                Icons.email_outlined,
                color: Color(0xffde2816),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Email',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.emailAddress,
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
              _validateEmail();
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
