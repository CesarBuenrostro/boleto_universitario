import 'package:boleto_universitario/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _perfilScreenState();
}

class _perfilScreenState extends State<PerfilScreen> {

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  void cargarUsuario() async {
    final api = ApiService();
    final data = await api.getUserData();

    setState(() {
      userData = data;
    });
  }


  bool isLoading = false;

 Future<void> _logout() async {
    setState(() => isLoading = true);

    await ApiService().logout();

    setState(() => isLoading = false);

    // Luego rediriges al login
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

    @override
    Widget build(BuildContext context) {

      // Datos simulados del usuario
      // final Map<String, String> user = {
      //   'nombre': 'Juan Pérez López456',
      //   'matricula': 'A01234567',
      //   'correo': 'juanp@universidad.edu.mx',
      //   'tipo': 'Estudiante',
      //   'boletosComprados': '12',
      //   'boletosUsados': '8',
      //   'boletosDisponibles': '4',
      // };

         // Si aún no se carga la info, muestra loader
      if (userData == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

          final String nombre = userData!['nombre'] ?? "Nombre no disponible";
          final String correo = userData!['correo'] ?? "Correo no disponible";
          final String tipo = userData!['rol'] ?? "Sin rol";
          final String matricula = userData!['matricula'] ?? "—";


      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Encabezado con avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.green[700],
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Text(
                  tipo,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 25),

                // Información del usuario
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Información personal",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          InfoTile(
                              icon: Icons.badge,
                              title: "Matrícula",
                              value: matricula),
                          InfoTile(
                              icon: Icons.email,
                              title: "Correo institucional",
                              value: correo),

                          const SizedBox(height: 20),

                          const Text(
                            "Estadísticas de boletos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // StatTile(
                          //   icon: Icons.shopping_bag,
                          //   label: "Comprados",
                          //   value: user['boletosComprados'].toString(),
                          //   color: Colors.blueAccent,
                          // ),
                          // StatTile(
                          //   icon: Icons.check_circle,
                          //   label: "Usados",
                          //   value: user['boletosUsados'].toString(),
                          //   color: Colors.green,
                          // ),
                          // StatTile(
                          //   icon: Icons.confirmation_number,
                          //   label: "Disponibles",
                          //   value: user['boletosDisponibles'].toString(),
                          //   color: Colors.orange,
                          // ),

                          // const SizedBox(height: 25),

                          // Botones de acción
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            label: const Text("Editar perfil"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: isLoading ? null : _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text("Cerrar sesión"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green[700],
                              side: BorderSide(color: Colors.green.shade700),
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
  




// Widget reutilizable para mostrar información personal
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(value),
    );
  }
}

// Widget reutilizable para estadísticas
class StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const StatTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
