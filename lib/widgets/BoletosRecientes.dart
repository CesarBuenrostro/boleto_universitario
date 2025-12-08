import 'package:flutter/material.dart';
import 'package:boleto_universitario/services/api_service.dart';

class BoletosRecientes extends StatefulWidget {
  final ApiService apiService;
  final String userId;
  final String? estado; // ← Nuevo parámetro

  const BoletosRecientes({
    super.key,
    required this.apiService,
    required this.userId,
    this.estado,
  });

  @override
  State<BoletosRecientes> createState() => _BoletosRecientesState();
}

class _BoletosRecientesState extends State<BoletosRecientes> {
  List<Map<String, dynamic>> boletos = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarBoletos();
  }

  Future<void> cargarBoletos() async {
    final data = await widget.apiService.getBoletosByUser(
    widget.userId,     // ← posicional
    estado: widget.estado, // ← opcional nombrado
  );

    if (mounted) {
      setState(() {
        boletos = List<Map<String, dynamic>>.from(data?["data"] ?? []);
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (boletos.isEmpty) {
      return Text(
        "Sin boletos ${widget.estado}",
        style: const TextStyle(color: Colors.white),
      );
    }

    return Column(
      children: boletos.map((boleto) {
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.directions_bus, color: Color(0xFF2E7D32)),
            title: Text("Boleto #${boleto['id_boleto']}"),
            subtitle: Text(
              "Ruta: ${boleto['id_ruta']} - Unidad: ${boleto['id_unidad']}",
            ),
            trailing: const Icon(Icons.check_circle_outline,
                color: Color(0xFF2E7D32)),
          ),
        );
      }).toList(),
    );
  }
}
