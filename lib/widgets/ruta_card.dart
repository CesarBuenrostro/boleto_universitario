import 'package:flutter/material.dart';

class RutaCard extends StatelessWidget {
  final Map<String, dynamic> ruta;
  final bool seleccionada;
  final VoidCallback onTap;

  const RutaCard({
    super.key,
    required this.ruta,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final precio = double.tryParse(ruta["precio"].toString())?.toStringAsFixed(2) ?? "0.00";

    return Card(
      color: seleccionada ? Colors.green[100] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ruta["nombre"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text("Origen: ${ruta['origen']}"),
                  ),
                ],
              ),

              Row(
                children: [
                  const Icon(Icons.flag, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text("Destino: ${ruta['destino']}"),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 6),
                  Text("Salida: ${ruta['hora_salida']}"),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 18),
                  const SizedBox(width: 6),
                  Text("Llegada: ${ruta['hora_llegada']}"),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "\$$precio",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
