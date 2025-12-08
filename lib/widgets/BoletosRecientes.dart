import 'package:flutter/material.dart';
import 'package:boleto_universitario/services/api_service.dart';
import 'package:qr_flutter/qr_flutter.dart';


class BoletosRecientes extends StatefulWidget {
  final ApiService apiService;
  final String userId;
  final String? estado; // ← Nuevo parámetro
  final bool shrink;

  const BoletosRecientes({
    super.key,
    required this.apiService,
    required this.userId,
    this.estado,
  this.shrink = false,
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

    return ListView.builder(
      shrinkWrap: widget.shrink,
      physics: widget.shrink ? NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.only(bottom: 32),
      itemCount: boletos.length,
      itemBuilder: (context, index) {
        final boleto = boletos[index];

        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.directions_bus, color: Color(0xFF2E7D32)),
            title: Text("Boleto #${boleto['id_boleto']}"),
            subtitle: Text("Ruta: ${boleto['id_ruta']} - Unidad: ${boleto['id_unidad']}"),
            trailing: IconButton(
              icon: const Icon(Icons.qr_code_2),
              color: Colors.green[800],
              onPressed: () {
                _mostrarQR(boleto);
              }
            )
          ),
        );
      },
    );
  }

void _mostrarQR(Map<String, dynamic> boleto) {
  final dataQR = boleto["codigo_qr"] ?? "SIN_DATOS";

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Código QR del Boleto"),
      content: SizedBox(
        width: 220,
        height: 260,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Center(
                child: QrImageView(
                  data: dataQR,
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "ID: ${boleto["id_boleto"]}",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    ),
  );
}


}
