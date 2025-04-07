import 'package:bite/components/titles/app_title.dart';
import 'package:bite/components/buttons/main_actionn_button.dart';
import 'package:bite/components/buttons/secondary_button.dart';
import 'package:bite/layouts/anonym_pages_layout.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The home screen
class HomeScreen extends StatelessWidget {
  /// Constructs a [HomeScreen]
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnonymPagesLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          AppTitle(
            fontSize: 96,
            imgSize: 64,
          ),
          SizedBox(height: 16),
          Text(
            'Take a bite in the good apple!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontSize: 26,
                ),
          ),
          Icon(Symbols.dentistry, size: 56, color: Color(0xffde2816)),
          SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SecondaryButton(
                  text: 'Sign up',
                  onPressed: () => router.go('/sign-up'),
                  icon: Icons.add_reaction_outlined,
                ),
                MainActionnButton(
                    text: 'Sign in',
                    icon: Icons.login_outlined,
                    onPressed: () => router.go('/sign-in'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
