import 'package:boleto_universitario/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:boleto_universitario/widgets/BoletosRecientes.dart';


class BoletosScreen extends StatefulWidget {
  const BoletosScreen({super.key});

  @override
  State<BoletosScreen> createState() => _BoletosScreenState();
}

class _BoletosScreenState extends State<BoletosScreen>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late ApiService apiService;
  String? userId;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _tabController = TabController(length: 2, vsync: this);

    cargarUsuario();
  }

  void cargarUsuario() async {
    final id = await apiService.getUserId();

    setState(() {
      userId = id;
      cargando = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.green),
        ),
      );
    }

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Error al obtener ID de usuario")),
      );
    }

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
              BoletosRecientes(
                apiService: apiService,
                userId: userId!,
                estado: "pendiente",
              ),
              BoletosRecientes(
                apiService: apiService,
                userId: userId!,
                estado: "validado",
              ),
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
}
