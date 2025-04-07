import 'package:bite/components/buttons/main_actionn_button.dart';
import 'package:bite/components/inputs/custom_text_input.dart';
import 'package:bite/components/inputs/phone.dart';
import 'package:bite/components/link.dart';
import 'package:bite/components/titles/app_title.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/anonym_pages_layout.dart';
import 'package:bite/services/router.dart';
import 'package:bite/validators/email.dart';
import 'package:bite/validators/password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:bite/components/inputs/email.dart';
import 'package:bite/components/inputs/password.dart';

import 'package:bite/validators/phone.dart';

import 'package:bite/services/auth_service.dart';
import 'package:material_symbols_icons/symbols.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController password = TextEditingController();

  late AuthService _authService;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authService = GetIt.instance<AuthService>();
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    if (firstName.text.isEmpty ||
        lastName.text.isEmpty ||
        !isValidEmail(email.text) ||
        !isValidPhone(phone.text) ||
        !isValidPassword(password.text)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AnonymPagesLayout(
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16),
          Row(
            children: [
              AppTitle(fontSize: 36, imgSize: 24),
              IconButton(
                  onPressed: () => context.go('/'),
                  icon: Icon(Icons.arrow_back))
            ],
          ),
          PageTitle(
            text: 'Happy to meet you !',
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Text(
                'Already have an account?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Link(text: 'Sign in !', route: 'sign-in', isExternal: false)
            ],
          ),
          CustomTextInput(
              label: "Firstname",
              placeholder: 'John',
              controller: firstName,
              onChanged: (value) => firstName.text = value,
              icon: Icons.person_2_outlined),
          CustomTextInput(
            label: "Lastname",
            placeholder: 'Doe',
            controller: lastName,
            onChanged: (value) => lastName.text = value,
            icon: Symbols.signature_rounded,
          ),
          EmailInput(
            controller: email,
            onChanged: (value) => email.text = value,
          ),
          PhoneInput(
            controller: phone,
            onChanged: (value) => phone.text = value,
          ),
          PasswordInput(
            controller: password,
            onChanged: (value) => password.text = value,
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: CircularProgressIndicator(),
            ),
          MainActionnButton(
            text: 'Register',
            icon: Icons.person_add_outlined,
            onPressed: _isLoading
                ? null
                : () async {
                    print('Registering user');
                    print('First name: ${firstName.text}');
                    print('Last name: ${lastName.text}');
                    print('Email: ${email.text}');
                    print('Phone: ${phone.text}');
                    print('Password: ${password.text}');
                    if (!_validateInputs()) return;

                    setState(() {
                      _isLoading = true;
                    });

                    bool success = false;
                    try {
                      success = await _authService.register(
                        firstName: firstName.text,
                        lastName: lastName.text,
                        email: email.text,
                        phone: phone.text,
                        password: password.text,
                      );
                    } catch (e) {
                      if (kDebugMode) print('Error: $e');
                      success = false;
                    }

                    if (success) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.white,
                        content: Text(
                          'Registration successful',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.teal),
                        ),
                      ));
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          router.go('/sign-in');
                        }
                      });
                    } else {
                      // TODO: Add error handling : #15
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Registration failed. Please try again.')),
                      );
                    }
                  },
          ),
        ],
      ),
    );
  }
}
