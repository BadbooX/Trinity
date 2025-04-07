import 'package:bite/services/auth_service.dart';
import 'package:bite/services/router.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';

final getIt = GetIt.instance;

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    //get authService instance
    final AuthService authService = getIt<AuthService>();

    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      backgroundColor: Color(0xffde1826),
      onTap: (value) => {
        switch (value) {
          (0) => {router.go('/')},
          (1) => {router.go('/profile')},
          (2) => {router.go('/cart')},
          (3) => {router.go('/scan')},
          (4) => {
              authService.logout(),
              router.go('/', extra: {'forceReload': true})
            },
          int() => throw UnimplementedError(),
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Symbols.grocery),
          label: 'Home',
          backgroundColor: Color(0xffde1826),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
          backgroundColor: Color(0xffde1826),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
          backgroundColor: Color(0xffde1826),
        ),
        BottomNavigationBarItem(
          icon: Icon(Symbols.barcode),
          label: 'Scan',
          backgroundColor: Color(0xffde1826),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.logout_outlined),
          label: 'Logout',
          backgroundColor: Color(0xffde1826),
        ),
      ],
    );
  }
}
