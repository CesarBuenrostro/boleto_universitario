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

      // Guardar token si viene
      if (data['token'] != null) {
        await storage.write(key: 'token', value: data['token']);
      }

      // Guardar datos del usuario
      if (data['usuario'] != null) {
        await storage.write(
            key: 'userId', value: data['usuario']['id'].toString());
        await storage.write(key: 'correo', value: data['usuario']['correo']);
        await storage.write(key: 'rol', value: data['usuario']['rol']);
        await storage.write(key: 'nombre', value: data['usuario']['nombre']);
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
  
  Future<String?> getUserId() async {
    return await storage.read(key: 'userId');
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

  // Método para comprar boleto - pendiente
  // static Future<Map<String, dynamic>?> ticketBuy(String idUsuario, String idRuta, String idUnidad, String fechaCompra, String codigoQr, String estado) async {
  
  // }

  // Método para obtener el saldo del usuario
Future<double?> saldoUser(String? id) async {
  try {
    final url = Uri.parse('$baseUrl/usuarios/saldo/$id');
    final response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final saldoStr = data["data"][0]["saldo"];
      print("SALDO RECIBIDO: $saldoStr");

      if (saldoStr != null) {
        return double.tryParse(saldoStr);
      }
    }

    print("Error al mostrar saldo de usuario");
    return null;

  } catch (error) {
    print("Excepción en mostrar saldo de usuario: $error");
    return null;
  }
}

  // Método para mostrar rutas disponibles
  Future<Map<String, dynamic>?> getRutas() async {
    try {
      final url = Uri.parse('http://192.168.0.6:3000/rutas');

      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          return jsonDecode(response.body);
        } else {
          print("Error al mostrar rutas");
          return null;
        }
    } catch (error) {
      print("Excepción en mostrar rutas: $error");
      return null;
    }
  }
}
