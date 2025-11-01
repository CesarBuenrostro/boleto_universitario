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
      case "Chofer":
        return const HomeDriverScreen();
      case "Administrativo":
        return const HomeScreen();
      case "Estudiante":
      default:
        return const HomeStudentScreen();
    }
  }
}
