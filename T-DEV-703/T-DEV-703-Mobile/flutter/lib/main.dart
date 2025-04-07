import 'package:bite/services/cart_service.dart';
import 'package:bite/services/product_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:bite/components/debug/debug_get_it.dart';

import 'package:bite/services/debug/debug_get_it.dart';
//import 'package:bite/services/user_service.dart';
import 'package:bite/services/auth_service.dart';
import 'package:bite/services/http_service.dart';
import 'package:bite/services/jwt_service.dart';
import 'package:bite/services/router.dart';
import 'package:bite/services/my_user_service.dart';
import 'package:bite/services/notifications_service.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  await dotenv.load(fileName: "assets/.env");
  assert(dotenv.isEveryDefined(['API_URL']),
      'API_URL variable not found in .env file');
  // init local notifications
  await NotificationService.initialize();
  // use DebugGetIt to register services it will add an extra layer of information for debugging instances
  DebugGetIt.registerSingleton<JwtService>(await JwtService.create());
  DebugGetIt.registerSingleton<HttpClientApi>(
      HttpClientApi(allowSelfSigned: kDebugMode));
  DebugGetIt.registerSingleton<AuthService>(AuthService()); // after jwt
  //DebugGetIt.registerSingleton<UserService>(UserService());
  DebugGetIt.registerSingleton<ProductService>(ProductService());
  DebugGetIt.registerSingleton<CartService>(CartService()); // after jwt
  DebugGetIt.registerSingleton<MyUserService>(MyUserService()); // after jwt
}

Future<void> main() async {
  if (kDebugMode) {
    print(" im a whale :3");
    //whale animal ascii art
    print('''
      __________...----..____..-'``-..___
    ,'.                                  ```--.._
   :                                             ``._
   |                           --                    ``.
   |                   -.-         -.     -   -.        `.
   :                     __           --            .     \\
    `._____________     (  `.   -.-      --  -   .   `     \\
       `-----------------\\   \\_.--------..__..--.._ `. `. :
                          `--'    Bite             `-._ .   |
                                                       `.`  |
                                                         \\` |
                                                          \\ |
                                                          / \\`.
                                                         /  _\\-'
                                                        /_,' 
                                                        ''');
  }

  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: GoogleFonts.raleway().fontFamily,
          brightness: Brightness.light,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFde1628),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
          ),
          textTheme: TextTheme(
              headlineLarge: GoogleFonts.wendyOne(fontSize: 36),
              headlineMedium: GoogleFonts.montserratAlternates(
                fontSize: 20,
              ),
              headlineSmall: GoogleFonts.montserratAlternates(
                fontSize: 18,
              ),
              bodyLarge: GoogleFonts.raleway(
                fontSize: 14,
              ),
              bodyMedium: GoogleFonts.raleway(
                fontSize: 12,
              ),
              bodySmall: GoogleFonts.raleway(
                fontSize: 10,
              ),
              labelLarge:
                  GoogleFonts.raleway(fontSize: 24, color: Colors.black))),
      builder: (context, child) {
        if (kDebugMode) {
          return Stack(
            children: [
              child!,
              GetItDebugWidget(
                // Add GetItDebugWidget to the widget tree to display registered instances with DebugGetIt
                registeredTypeNames: DebugGetIt.registeredTypes
                    .map((type) => type.toString())
                    .toList(),
              ),
            ],
          );
        } else {
          return child!;
        }
      },
    );
  }
}
