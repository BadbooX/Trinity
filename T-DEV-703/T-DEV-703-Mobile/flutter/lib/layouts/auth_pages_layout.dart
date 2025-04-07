import 'package:bite/components/bottom_nav_bar.dart';
import 'package:bite/components/titles/app_title.dart';
import 'package:flutter/material.dart';

class AuthPagesLayout extends StatelessWidget {
  final Widget child;

  const AuthPagesLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AppTitle(fontSize: 34, imgSize: 45),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
