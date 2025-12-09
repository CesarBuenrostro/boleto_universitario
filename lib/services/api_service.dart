import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://boletoapi-production.up.railway.app';
  final storage = const FlutterSecureStorage();

// Login de usuario
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
        await storage.write(key: 'matricula', value: data['usuario']['matricula']);
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

  // Método para obtener información del usuario en Storage
  Future<Map<String, dynamic>?> getUserData() async {
  try {
    final userId = await storage.read(key: 'userId');
    final nombre = await storage.read(key: 'nombre');
    final correo = await storage.read(key: 'correo');
    final rol = await storage.read(key: 'rol');
    final matricula = await storage.read(key: 'matricula');

    if (userId == null) return null; // Si no hay usuario, no hay sesión

    return {
      'id': userId,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'matricula': matricula,
    };
  } catch (e) {
    print("Error al obtener datos del usuario: $e");
    return null;
  }
}


  // Cerrar sesión:
  Future<void> logout() async {
    await storage.delete(key: 'token');
  }

  // Método para crear cuanta de usuario
  static Future<Map<String, dynamic>?> register(String nombre, String correo, String contrasena, String tipoUsuario, String matricula) async {
    try {
      final url = Uri.parse('https://boletoapi-production.up.railway.app/usuarios'); // no puedo la ruta base por que el método es estático

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "correo": correo,
          "contrasena": contrasena,
          "rol": tipoUsuario.toLowerCase(),
          "matricula": matricula,
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
      final url = Uri.parse('$baseUrl/rutas');

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

// Obtener boletos por usuario (y opcionalmente por estado)
Future<Map<String, dynamic>?> getBoletosByUser(String userId, {String? estado}) async {
  try {
    // Construir parámetros dinámicos
    final queryParams = {
      'usuario': userId,
      if (estado != null) 'estado': estado,
    };

    final url = Uri.parse('$baseUrl/boletos').replace(queryParameters: queryParams);

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print("Error al obtener boletos del usuario");
      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");
      return null;
    }
  } catch (error) {
    print("Excepción al obtener boletos: $error");
    return null;
  }
}

Future<Map<String, dynamic>> comprarBoletos({
    required String userId,
    required String idRuta,
    required String idUnidad,
    required int cantidad,
    required double monto,
    required String metodo,
  }) async {
    final url = Uri.parse("$baseUrl/boletos");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id_usuario": userId,
          "id_ruta": idRuta,
          "id_unidad": 1,
          "cantidad": cantidad,
          "monto": monto,
          "metodo": metodo,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error al comprar boletos: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error en la solicitud: $e");
    }
  }


Future<Map<String, dynamic>> validarBoleto(String codigoQR) async {
    final url = Uri.parse("$baseUrl/boletos/validar/$codigoQR");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        );

      if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 404) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Error inesperado del servidor (${response.statusCode})"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión con el servidor",
        "error": e.toString()
      };
    }
  }

}
