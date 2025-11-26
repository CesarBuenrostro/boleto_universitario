import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.6:3000'; // Ajusta según tu configuración
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/usuarios/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo': email, 'contrasena': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // ⚡ Aquí guardamos el token si viene en la respuesta
        if (data['token'] != null) {
          await storage.write(key: 'token', value: data['token']);
          print('Token guardado: ${data['token']}');
        }

        return data;
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
  }

  //  Método extra para leer el token cuando lo necesites
  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  // Cerrar sesión:
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  // Método para crear cuanta de usuario

  static Future<Map<String, dynamic>?> register(String nombre, String correo, String contrasena, String tipoUsuario) async {
    try {
      final url = Uri.parse('http://192.168.0.6:3000/usuarios');

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "correo": correo,
          "contrasena": contrasena,
          "rol": tipoUsuario.toLowerCase()
        }),
      );
      
     if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        print("Error en Registro: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Excepción en registro(): $error");
      return null;
    }
  }


}
