import 'package:flutter/material.dart';
import 'package:bite/validators/phone.dart';

class PhoneInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const PhoneInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  PhoneInputState createState() => PhoneInputState();
}

class PhoneInputState extends State<PhoneInput> {
  String? phoneError;

  // Phone validation logic
  void _validatePhone() {
    final phoneText = widget.controller.text;
    if (phoneText.isEmpty) {
      phoneError = 'Please enter a phone number';
    } else if (!isValidPhone(phoneText)) {
      phoneError = 'Please enter a valid phone number';
    } else {
      phoneError = null; // No error means the input is OK
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone_outlined,
                color: Color(0xffde2816),
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Phone',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          TextField(
            controller: widget.controller,
            keyboardType: TextInputType.phone,
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
              _validatePhone();
              widget.onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
