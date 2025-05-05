import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/list_videojuegos_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/product_detail_screen.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static final Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginScreen(),
    'register': (_) => const RegisterScreen(),
    'list': (_) => const ListVideojuegosScreen(),
    'cart': (_) => const CartScreen(),
    'detail': (_) => const Placeholder(),
  };
}