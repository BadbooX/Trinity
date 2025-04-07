import 'package:bite/components/buttons/main_actionn_button.dart';
import 'package:bite/components/link.dart';
import 'package:bite/components/titles/app_title.dart';
import 'package:bite/components/titles/page_title.dart';
import 'package:bite/layouts/anonym_pages_layout.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:bite/services/auth_service.dart';
import 'package:bite/components/inputs/email.dart';
import 'package:bite/components/inputs/password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
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
    email.dispose();
    password.dispose();
    super.dispose();
  }

  bool _validateInputs() {
    return true; // Adjust based on your validation logic
  }

  @override
  Widget build(BuildContext context) {
    return AnonymPagesLayout(
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 8),
              AppTitle(fontSize: 36, imgSize: 24),
              SizedBox(width: 8),
              IconButton(
                  onPressed: () => router.go('/'), icon: Icon(Icons.arrow_back))
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PageTitle(text: 'Welcome back!'),
            ],
          ),
          // Corrected typo here
          EmailInput(
            controller: email,
            onChanged: (value) {},
          ),
          PasswordInput(
            controller: password,
            onChanged: (value) {},
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.only(bottom: 16.0),
              child: CircularProgressIndicator(),
            ),
          MainActionnButton(
            text: 'Login',
            icon: Icons.login_outlined,
            onPressed: _isLoading
                ? null
                : () async {
                    if (!_validateInputs()) return;

              setState(() {
                _isLoading = true;
              });

              bool success = await _authService.login(
                email.text,
                password.text,
              );

              if (!mounted) return;

              setState(() {
                _isLoading = false;
              });

                    if (success) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.white,
                          content: Text('Welcome back!',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: Colors.teal)),
                        ),
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          router.go('/');
                        }
                      });
                    } else {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.white,
                            content: Text(
                              'Login failed. Please try again.',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 184, 16, 30)),
                            )),
                      );
                    }
                  },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Text('No account yet ?',
                  style: Theme.of(context).textTheme.bodyMedium),
              Link(text: 'Sign up !', route: 'sign-up', isExternal: false)
            ],
          )
        ],
      ),
    );
  }
}
