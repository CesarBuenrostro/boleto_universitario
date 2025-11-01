import 'package:flutter/material.dart';
import 'dart:async';

class ValidarBoletoScreen extends StatefulWidget {
  const ValidarBoletoScreen({super.key});

  @override
  State<ValidarBoletoScreen> createState() => _ValidarBoletoScreenState();
}

class _ValidarBoletoScreenState extends State<ValidarBoletoScreen>
    with SingleTickerProviderStateMixin {
  bool escaneando = false;
  String mensaje = "Apunta la cámara al código QR del boleto";
  Color colorMensaje = Colors.black87;

  late AnimationController _controller;
  late Animation<double> _animacion;

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
    super.dispose();
  }

  void simularEscaneo() {
    setState(() {
      escaneando = true;
      mensaje = "Escaneando...";
      colorMensaje = Colors.black87;
    });

    // Simula el tiempo de lectura del QR
    Timer(const Duration(seconds: 2), () {
      final valido = DateTime.now().second % 2 == 0; // validación aleatoria

      setState(() {
        escaneando = false;
        if (valido) {
          mensaje = "✅ Boleto válido. ¡Bienvenido a bordo!";
          colorMensaje = Colors.green[800]!;
        } else {
          mensaje = "❌ Boleto inválido. Intenta nuevamente.";
          colorMensaje = Colors.red[700]!;
        }
      });
    });
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner,
                size: 80, color: Colors.black54),
            const SizedBox(height: 10),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: colorMensaje,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            // Cuadro de simulación del escaneo
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green, width: 4),
                    color: Colors.white,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animacion,
                  builder: (context, child) {
                    return Positioned(
                      top: 250 * _animacion.value,
                      child: Container(
                        width: 230,
                        height: 3,
                        color: Colors.greenAccent,
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: escaneando ? null : simularEscaneo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C853),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.qr_code, color: Colors.white),
              label: const Text(
                "Simular escaneo",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
