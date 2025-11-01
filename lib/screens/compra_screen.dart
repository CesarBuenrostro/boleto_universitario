import 'package:flutter/material.dart';

class ComprarBoletosScreen extends StatefulWidget {
  const ComprarBoletosScreen({super.key});

  @override
  State<ComprarBoletosScreen> createState() => _ComprarBoletosScreenState();
}

class _ComprarBoletosScreenState extends State<ComprarBoletosScreen> {
  final List<Map<String, dynamic>> rutas = [
    {
      "nombre": "Ruta A - Campus Norte",
      "hora": "07:30 AM",
      "precio": 10.0,
    },
    {
      "nombre": "Ruta B - Campus Sur",
      "hora": "08:00 AM",
      "precio": 12.0,
    },
    {
      "nombre": "Ruta C - Campus Centro",
      "hora": "09:15 AM",
      "precio": 8.5,
    },
  ];

  int cantidad = 1;
  double total = 0.0;
  Map<String, dynamic>? rutaSeleccionada;

  void calcularTotal() {
    if (rutaSeleccionada != null) {
      setState(() {
        total = cantidad * (rutaSeleccionada!['precio'] as num).toDouble();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comprar Boletos"),
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Selecciona una ruta",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: rutas.length,
                  itemBuilder: (context, index) {
                    final ruta = rutas[index];
                    final seleccionada = rutaSeleccionada == ruta;
                    return Card(
                      color: seleccionada ? Colors.green[100] : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(ruta["nombre"]),
                        subtitle: Text("Salida: ${ruta["hora"]}"),
                        trailing: Text("\$${ruta["precio"].toStringAsFixed(2)}"),
                        onTap: () {
                          setState(() {
                            rutaSeleccionada = ruta;
                            calcularTotal();
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (rutaSeleccionada != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Cantidad:",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            if (cantidad > 1) {
                              setState(() {
                                cantidad--;
                                calcularTotal();
                              });
                            }
                          },
                        ),
                        Text(
                          "$cantidad",
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              cantidad++;
                              calcularTotal();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "Total: \$${total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Compra realizada exitosamente 🎟️"),
                      ),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Comprar",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ] else
                const Text(
                  "Selecciona una ruta para continuar",
                  style: TextStyle(color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
