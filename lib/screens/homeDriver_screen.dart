import 'package:boleto_universitario/services/api_service.dart';
import 'package:boleto_universitario/widgets/saldo_user.dart';
import 'package:flutter/material.dart';
import 'package:boleto_universitario/screens/validacion_screen.dart';
import 'package:boleto_universitario/screens/profile_screen.dart';

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({super.key});

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {

    String? userId;
    Map<String, dynamic>? datosSaldo;

    @override
      void initState() {
        super.initState();
        cargarUsuario();
      }

    void cargarUsuario() async {
      final api = ApiService();
      final id = await api.getUserId();
      // print("desde pantalla: $id");

      setState(() {
        userId = id;
      });
    }

  int _selectedIndex = 0;

  List<Map<String, dynamic>> get menuItems {
    return [
      {
      'page': HomeContent(userId: userId),
      'icon': Icons.home_outlined,
      'label': 'Inicio',
    },
    {
      'page': const ValidarBoletoScreen(),
      'icon': Icons.qr_code_scanner_outlined,
      'label': 'Validar',
    },
    {
      'page': const PerfilScreen(),
      'icon': Icons.person_outline,
      'label': 'Perfil',
    },
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = menuItems[_selectedIndex]['page'] as Widget;

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF2E7D32),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: menuItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item['icon']),
                label: item['label'],
              ),
            )
            .toList(),
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1B5E20),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/compra');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// ----------- HOME CONTENT -----------
class HomeContent extends StatelessWidget {
  final String? userId;
  const HomeContent({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    

    final List<String> avisos = [
      'El servicio de las 9:00 AM tendrá retraso por mantenimiento.',
      'Recuerda renovar tu pase mensual antes del 25 de octubre.',
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Bienvenido Chofer 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aquí puedes ver tu saldo   y avisos importantes.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Saldo disponible
            SaldoCard(userId: userId),

            

            // Avisos del sistema
            const Text(
              'Avisos del sistema',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...avisos.map((aviso) => Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.notifications_active,
                            color: Color(0xFF2E7D32)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            aviso,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

