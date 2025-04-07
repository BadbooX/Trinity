import 'package:bite/views/scanner_view.dart';
import 'package:bite/services/auth_service.dart';
import 'package:bite/views/auth/register.dart';
import 'package:bite/views/cart.dart';
import 'package:bite/views/home_logged.dart';
import 'package:bite/views/product.dart';
import 'package:bite/views/profile/profile.dart';
import 'package:bite/views/search_product.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:bite/views/orders/order_page.dart';
import 'package:bite/views/payment/payment_status_page.dart';
import '../views/home.dart';
import '../views/auth/login.dart';

final GetIt getIt = GetIt.instance;

//! check https://pub.dev/packages/go_router/example on how to use the go_router package (page level routing)
final GoRouter router = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: (context, state) {
      final AuthService authService = getIt.get<AuthService>();
      final extra = state.extra as Map<String, dynamic>?;
      final key =
          extra != null && extra['forceReload'] == true ? UniqueKey() : null;
      return authService.isLoggedIn
          ? HomeLogged(key: key)
          : HomeScreen(key: key);
    },
    routes: [
      GoRoute(
          path: "sign-in",
          builder: (context, state) {
            return LoginPage();
          }),
      GoRoute(
          path: "sign-up",
          builder: (context, state) {
            return RegisterPage();
          }),
      GoRoute(
          path: "/profile",
          builder: (context, state) {
            return ProfilePage();
          }),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
          path: '/profile/add-address',
          builder: (context, state) {
            return const EditUserAddress();
      }),
      GoRoute(
          path: "/product/:idProduct",
          builder: (context, state) {
            return ProductView(idProduct: state.pathParameters['idProduct']!);
          }),
      GoRoute(
          path: '/cart',
          builder: (context, state) {
            return CartView();
          }),
      
      GoRoute(
          path: "/scan",
          builder: (context, state) {
            return ScannerView();
          }),
      GoRoute(
        path: '/search/:barcode',
        builder: (context, state) {
          return SearchProductView(barCode: state.pathParameters['barcode']!);
        },
      ),
            GoRoute(
        path:  '/orders',
        builder: (context, state){
          return OrderPage();
        }
      ),
      GoRoute(
        path: "/payment-status",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return PaymentStatusPage(
            status: extra["status"] ?? "error",
            total: extra["total"],
            currency: extra["currency"],
            items: extra["items"],
          );
        },
      ),
      // GoRoute(
      //     name: "product",
      //     path: "product/:qrcode",
      //     builder: (context, state) {
      //       return ProductScreen(qrCode: state.pathParameters['qrcode']!);
      //     })
    ],
  ),
]);
