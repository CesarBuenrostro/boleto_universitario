import 'package:flutter/material.dart';
import 'package:boleto_universitario/screens/ticket_screen.dart';
import 'package:boleto_universitario/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

 final List<Map<String, dynamic>> _menuItems = [
    {
      'page': const HomeContent(),
      'icon': Icons.home_outlined,
      'label': 'Inicio',
    },
    {
      'page': const BoletosScreen(),
      'icon': Icons.confirmation_num_outlined,
      'label': 'Boletos',
    },
    {
      'page': const PerfilScreen(),
      'icon': Icons.person_outline,
      'label': 'Perfil',
    },
    // futura sección de Métricas
    // {
    //   'page': const MetricsScreen(),
    //   'icon': Icons.bar_chart_outlined,
    //   'label': 'Métricas',
    // },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _menuItems[_selectedIndex]['page'] as Widget;

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: const Color(0xFF2E7D32),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        type: BottomNavigationBarType.fixed,
        items: _menuItems
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
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Datos simulados
    final double saldo = 120.50;
    final List<Map<String, String>> boletos = [
      {'destino': 'Campus Central', 'fecha': '21 Oct 2025', 'hora': '08:15 AM'},
      {'destino': 'Campus Norte', 'fecha': '20 Oct 2025', 'hora': '07:45 AM'},
    ];

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
              'Bienvenido Administrativo 👋',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aquí puedes ver tu saldo, boletos recientes y avisos importantes.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            // Saldo disponible
            Card(
              color: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet,
                        color: Color(0xFF2E7D32), size: 32),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Saldo disponible',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text('\$$saldo MXN',
                            style: const TextStyle(
                                fontSize: 20, color: Color(0xFF2E7D32))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Boletos recientes
            const Text(
              'Últimos boletos',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...boletos.map((boleto) => Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.directions_bus,
                        color: Color(0xFF2E7D32)),
                    title: Text(boleto['destino']!),
                    subtitle:
                        Text('${boleto['fecha']} - ${boleto['hora']}'),
                    trailing: const Icon(Icons.check_circle_outline,
                        color: Color(0xFF2E7D32)),
                  ),
                )),
            const SizedBox(height: 20),

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

// ----------- OTRAS PÁGINAS -----------

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Boletos (en desarrollo)'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Pantalla de Perfil (en desarrollo)'),
    );
  }
}
