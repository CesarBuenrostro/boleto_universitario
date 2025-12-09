import 'package:flutter/material.dart';
import 'package:boleto_universitario/services/api_service.dart';

class RecargarSaldoScreen extends StatefulWidget {
  const RecargarSaldoScreen({super.key});

  @override
  State<RecargarSaldoScreen> createState() => _RecargarSaldoScreenState();
}

class _RecargarSaldoScreenState extends State<RecargarSaldoScreen> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController montoController = TextEditingController();

  Map<String, dynamic>? userData;
  bool cargando = false;
  final api = ApiService();

  Future<void> buscarUsuario() async {
    setState(() => cargando = true);

    final id = userIdController.text.trim();
    final response = await api.obtenerDatosUsuario(id);

    final data = response["data"];
    final success = response["success"].toString() == "true" ||
        response["success"] == true ||
        response["success"] == 1;

    if (success && data is List && data.isNotEmpty && data[0] is Map) {
      setState(() {
        userData = Map<String, dynamic>.from(data[0]);
        cargando = false;
      });
    } else {
      setState(() {
        userData = null;
        cargando = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"] ?? "Sin mensaje")),
    );
  }

  Future<void> recargarSaldo() async {
    final id = userIdController.text.trim();
    final monto = double.tryParse(montoController.text.trim());

    if (monto == null || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ingresa un monto válido")),
      );
      return;
    }

    setState(() => cargando = true);
    final response = await api.recargarSaldo(id, monto);
    setState(() => cargando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response["message"])),
    );

    if (response["success"] == true) {
      buscarUsuario();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recargar Saldo"),
        backgroundColor: const Color(0xFF00C853),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // FONDO DEGRADADO
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // CONTENIDO
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: userIdController,
                  decoration: InputDecoration(
                    labelText: "ID del usuario",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: cargando ? null : buscarUsuario,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Buscar usuario", 
                  style: TextStyle(color: Colors.white)
                  ),
                ),

                const SizedBox(height: 20),

                if (userData != null) _buildUserCard(),
              ],
            ),
          ),

          if (cargando)
            Container(
              color: Colors.black45,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Usuario: ${userData!["nombre"]}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "Saldo actual: \$${userData!["saldo"]}",
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: montoController,
            decoration: InputDecoration(
              labelText: "Monto a recargar",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            keyboardType: TextInputType.number,
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: cargando ? null : recargarSaldo,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Aplicar recarga",
                  style: TextStyle(color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}
