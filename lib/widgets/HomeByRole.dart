import 'package:flutter/material.dart';
import '/screens/home_screen.dart';
import '/screens/homeStudent_screen.dart';
import '/screens/homeDriver_screen.dart';



class HomeByRole extends StatelessWidget {
  final String tipoUsuario;

  const HomeByRole({super.key, required this.tipoUsuario});

  @override
  Widget build(BuildContext context) {
    switch (tipoUsuario) {
      case "chofer":
        return const HomeDriverScreen();
      case "admin":
        return const HomeScreen();
      case "estudiante":
      default:
        return const HomeStudentScreen();
    }
  }
}
