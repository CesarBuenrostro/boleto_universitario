import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class ValidarBoletoScreen extends StatefulWidget {
  const ValidarBoletoScreen({super.key});

  @override
  State<ValidarBoletoScreen> createState() => _ValidarBoletoScreenState();
}

class _ValidarBoletoScreenState extends State<ValidarBoletoScreen>
    with SingleTickerProviderStateMixin {
  final ApiService api = ApiService();
  bool procesando = false;
  String mensaje = "Apunta la cámara al código QR del boleto";
  Color colorMensaje = Colors.black87;

  late AnimationController _controller;
  late Animation<double> _animacion;

  // Control del escáner
  final MobileScannerController scannerController = MobileScannerController();
  bool haEscaneado = false; // Evita lecturas múltiples del mismo QR

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _animacion = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    scannerController.dispose();
    super.dispose();
  }

  Future<void> procesarCodigo(String codigoQR) async {
    if (procesando) return;

    setState(() {
      procesando = true;
      mensaje = "Validando boleto...";
      colorMensaje = Colors.black87;
    });

    final resultado = await api.validarBoleto(codigoQR);

    setState(() {
      if (resultado["success"] == true) {
        mensaje = "✅ Boleto válido. ¡Bienvenido a bordo!";
        colorMensaje = Colors.green[800]!;
      } else {
        mensaje = "❌ ${resultado["message"] ?? "Boleto inválido"}";
        colorMensaje = Colors.red[700]!;
      }

      procesando = false;
    });
  }

  void resetearEscaneo() async {
    setState(() {
      haEscaneado = false;
      mensaje = "Apunta la cámara al código QR del boleto";
      colorMensaje = Colors.black87;
    });

    // Reiniciamos la cámara para poder volver a escanear
    try {
      await scannerController.start();
    } catch (e) {
      // ignore, si no se pudo iniciar no queremos romper la UI
      print("No se pudo reiniciar la cámara: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Validar Boleto"),
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
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE8F5E9), Color(0xFFF1F8E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: colorMensaje,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            // Vista de la cámara con overlay y animación
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 300,
                  height: 300,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green, width: 4),
                  ),
                  child: MobileScanner(
                    controller: scannerController,
                    onDetect: (capture) async {
                      if (haEscaneado) return;
                      haEscaneado = true;

                      // Para mayor seguridad, detenemos la cámara inmediatamente
                      try {
                        await scannerController.stop();
                      } catch (_) {}


                      final List<Barcode> barcodes = capture.barcodes;

                      if (barcodes.isNotEmpty) {
                        final valorQR = barcodes.first.rawValue ?? "";
                        procesarCodigo(valorQR);
                      }
                    },
                  ),
                ),

                // Línea animada estilo escáner
                AnimatedBuilder(
                  animation: _animacion,
                  builder: (context, child) {
                    return Positioned(
                      top: 300 * _animacion.value,
                      child: Container(
                        width: 260,
                        height: 4,
                        color: Colors.greenAccent,
                      ),
                );
              },
            ),
          ],
        ),

            const SizedBox(height: 40),

            ElevatedButton.icon(
              onPressed: procesando ? null : resetearEscaneo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.restart_alt, color: Colors.white),
              label: const Text(
                "Reintentar escaneo",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
