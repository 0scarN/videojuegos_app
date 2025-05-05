import 'package:flutter/material.dart';
import 'package:videojuegos/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:videojuegos/services/auth_service.dart';
import 'services/videojuego_service.dart';
import 'providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VideojuegoService()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Videojuegos App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: AppRoutes.routes,
    );
  }
}