import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

// agregar restriccion maxima de boletos de "40"


class BoletosScreen extends StatefulWidget {
  const BoletosScreen({super.key});

  @override
  State<BoletosScreen> createState() => _BoletosScreenState();
}

class _BoletosScreenState extends State<BoletosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> boletosActivos = [
    {
      "id": "B001",
      "origen": "Campus Norte",
      "destino": "Campus Sur",
      "fecha": "21/10/2025",
      "hora": "07:30 AM",
      "estado": "activo"
    },
    {
      "id": "B002",
      "origen": "Campus Sur",
      "destino": "Centro",
      "fecha": "21/10/2025",
      "hora": "18:00 PM",
      "estado": "activo"
    },
  ];

  final List<Map<String, String>> boletosUsados = [
    {
      "id": "B003",
      "origen": "Centro",
      "destino": "Campus Norte",
      "fecha": "20/10/2025",
      "hora": "07:00 AM",
      "estado": "usado"
    },
    {
      "id": "B004",
      "origen": "Campus Sur",
      "destino": "Centro",
      "fecha": "19/10/2025",
      "hora": "17:45 PM",
      "estado": "usado"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Boletos"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: "Activos", icon: Icon(Icons.confirmation_num_outlined)),
            Tab(text: "Usados", icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          top: false,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildListaBoletos(boletosActivos),
              _buildListaBoletos(boletosUsados),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B5E20),
        onPressed: () {
          Navigator.pushNamed(context, '/comprar');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListaBoletos(List<Map<String, String>> boletos) {
    if (boletos.isEmpty) {
      return const Center(
        child: Text(
          "No hay boletos en esta sección",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: boletos.length,
      itemBuilder: (context, index) {
        final boleto = boletos[index];
        final bool activo = boleto["estado"] == "activo";

        return Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(
              activo ? Icons.check_circle : Icons.history,
              color: activo ? Colors.green[800] : Colors.grey[600],
              size: 36,
            ),
            title: Text(
              "${boleto["origen"]} → ${boleto["destino"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${boleto["fecha"]} • ${boleto["hora"]}"),
            trailing: IconButton(
              icon: const Icon(Icons.qr_code_2),
              color: Colors.green[800],
              onPressed: () {
                _mostrarQR(boleto);
              },
            ),
          ),
        );
      },
    );
  }

  void _mostrarQR(Map<String, String> boleto) {
    final dataQR = jsonEncode({
      "id": boleto["id"],
      "origen": boleto["origen"],
      "destino": boleto["destino"],
      "fecha": boleto["fecha"],
      "hora": boleto["hora"],
      "estado": boleto["estado"]
    });

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Código QR del Boleto"),
        content: SizedBox(
  width: 220, // Tamaño fijo para asegurar el layout
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
        "ID: ${boleto["id"]}",
        style: const TextStyle(fontSize: 14),
      ),
    ],
  ),
),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
        ],
      ),
    );
  }
}
