import 'package:boleto_universitario/widgets/HomeByRole.dart';
import 'package:boleto_universitario/widgets/ruta_card.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ComprarBoletosScreen extends StatefulWidget {
  const ComprarBoletosScreen({super.key});

  @override
  State<ComprarBoletosScreen> createState() => _ComprarBoletosScreenState();
}

class _ComprarBoletosScreenState extends State<ComprarBoletosScreen> {

  late Future<List<dynamic>?> futureRutas;

  String? userId; 
  Map<String, dynamic>? userData;

@override
void initState() {
  super.initState();
  cargarRutas();
  cargarUsuario();
}

void cargarUsuario() async {
  final api = ApiService();
  final id = await api.getUserId();
  final data = await api.getUserData(); // Map<String, dynamic>?

  setState(() {
    userId = id;
    userData = data; // Map completo
  });
}



  List<Map<String, dynamic>> rutas = [];
  bool cargando = true;

  Future<void> cargarRutas() async {
    final data = await ApiService().getRutas();

    if (mounted) {
      setState(() {
        if (data != null && data['data'] != null) {
          rutas = List<Map<String, dynamic>>.from(data['data']).map((r) {
            final precioRaw = r["precio"];

            final precio = precioRaw is num
                ? precioRaw.toDouble()
                : double.tryParse(precioRaw.toString()) ?? 0.0;

            return {
              ...r,
              "precio": precio,
            };
          }).toList();
        }
        cargando = false;
      });
    }
  }

  int cantidad = 1;
  double total = 0.0;
  Map<String, dynamic>? rutaSeleccionada;

  void calcularTotal() {
    if (rutaSeleccionada != null) {
      setState(() {
        final precio = double.tryParse(rutaSeleccionada!['precio'].toString()) ?? 0.0;
        total = cantidad * precio;
      });
    }
  }

  // ⭐ Método para llamar al Future comprarBoletos()
  Future<void> _realizarCompra() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No se encontró el usuario.")),
      );
      return;
    }

    final ruta = rutaSeleccionada!;
    final api = ApiService();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final result = await api.comprarBoletos(
        userId: userId!,
        idRuta: ruta["id"].toString(),
        idUnidad: ruta["id_unidad"].toString(),
        cantidad: cantidad,
        monto: total,
        metodo: "saldo",
      );
      

      Navigator.pop(context); // Cerrar loader

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Compra exitosa"),
          content: const Text("Tus boletos han sido generados 🎟️"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeByRole(tipoUsuario: userData?['rol']), // aquiiiiiiiiiii
                  ),
                );
              },
              child: const Text("Aceptar"),
            )
          ],
        ),
      );

      print("Boletos generados: ${result['data']['boletos']}");
    } catch (e) {
      Navigator.pop(context); // Cerrar loader

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("No se pudo completar la compra.\n$e"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            )
          ],
        ),
      );
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
                child: cargando
                    ? const Center(child: CircularProgressIndicator())
                    : rutas.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay rutas disponibles",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                          )
                        : ListView.builder(
                            itemCount: rutas.length,
                            itemBuilder: (context, index) {
                              final ruta = rutas[index];
                              final seleccionada = rutaSeleccionada == ruta;

                              return RutaCard(
                                ruta: ruta,
                                seleccionada: seleccionada,
                                onTap: () {
                                  setState(() {
                                    rutaSeleccionada = ruta;
                                    calcularTotal();
                                  });
                                },
                              );
                            },
                          ),
              ),
              const SizedBox(height: 20),
              if (rutaSeleccionada != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Cantidad:", style: TextStyle(fontSize: 16)),
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
                        Text("$cantidad", style: const TextStyle(fontSize: 18)),
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

                // ⭐ Botón modificado
                ElevatedButton(
  onPressed: () async {
    if (userId == null || rutaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: falta información del usuario o ruta")),
      );
      return;
    }

    final api = ApiService();

    final response = await api.comprarBoletos(
          userId: userId!,
          idRuta: rutaSeleccionada!['id_ruta'].toString(),
          idUnidad: rutaSeleccionada!['id_unidad'].toString(),
          cantidad: cantidad,
          monto: total,
          metodo: "saldo", // o efectivo, depende de tu lógica
        );

        if (response != null && response["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Compra realizada exitosamente 🎟️")),
          );
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeByRole(tipoUsuario: userData?['rol']), // aquiiiiiiiiiii
              ),
            ); // llllllllllllllllllll
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al realizar la compra")),
          );
        }
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
    )

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
