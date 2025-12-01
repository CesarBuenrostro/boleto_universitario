import 'package:flutter/material.dart';
import '../services/api_service.dart';


class SaldoCard extends StatefulWidget {
  
  final String? userId;

  const SaldoCard({super.key, required this.userId});

  @override
  State<SaldoCard> createState() => _SaldoCardState();
}

class _SaldoCardState extends State<SaldoCard> {
  double? saldo;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarSaldo();
  }

  Future<void> cargarSaldo() async {
    final data = await ApiService().saldoUser(widget.userId);

    setState(() {
        saldo = data;
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text("Cargando saldo..."),
                ],
              ),
            ),
          )
        : Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF2E7D32),
                    size: 32,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Saldo disponible',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        saldo != null ? '\$${saldo!.toStringAsFixed(2)} MXN' : "—",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
