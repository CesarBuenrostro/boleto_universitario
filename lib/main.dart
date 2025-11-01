import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/compra_screen.dart';
import 'screens/validacion_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/ticket_screen.dart';
import 'screens/createAccount.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const BoletoApp());
}

class BoletoApp extends StatelessWidget {
  const BoletoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boletos Universitarios',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const WelcomeScreen(),
        "/onboarding": (context) => const WelcomeScreen(),
        "/createAccount": (context) => const CrearCuentaScreen(),
        "/login": (context) => const LoginScreen(),
        "/home": (context) => const HomeScreen(),
        "/compra": (context) => const ComprarBoletosScreen(),
        "/validacion": (context) => const ValidarBoletoScreen(),
        "/tickets": (context) => const BoletosScreen(),
        "/perfil": (context) => const PerfilScreen(),
      },
    );
  }
}
