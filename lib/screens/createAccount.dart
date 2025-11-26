import 'package:flutter/material.dart';
import '../services/api_service.dart';  // importa tu ApiService

class CrearCuentaScreen extends StatefulWidget {
  const CrearCuentaScreen({super.key});

  @override
  State<CrearCuentaScreen> createState() => _CrearCuentaScreenState();
}

class _CrearCuentaScreenState extends State<CrearCuentaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  String? tipoUsuario;
  bool isLoading = false;

  Future<void> _crearCuenta() async {
    if (!_formKey.currentState!.validate()) return;

    if (tipoUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecciona un tipo de usuario")),
      );
      return;
    }

    setState(() => isLoading = true);

    // traducir roles para la API
    final String rolAPI = {
      "Estudiante": "estudiante",
      "Chofer": "chofer",
      "Administrativo": "admin"
    }[tipoUsuario]!;

    final result = await ApiService.register(
      nombreController.text.trim(),
      correoController.text.trim(),
      contrasenaController.text.trim(),
      rolAPI, // estudiante, chofer, administrativo
    );

    setState(() => isLoading = false);

    if (result != null && result["success"] == true) {
      // Éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cuenta creada exitosamente"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result?["message"] ?? "Error al crear cuenta"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/logo.png', height: 120),
                      const SizedBox(height: 10),
                      const Text(
                        "Crear cuenta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildTextField(
                          controller: nombreController,
                          label: "Nombre completo",
                          icon: Icons.person),

                      const SizedBox(height: 15),

                      _buildTextField(
                          controller: matriculaController,
                          label: "Matrícula de estudiante",
                          icon: Icons.badge),

                      const SizedBox(height: 15),

                      _buildTextField(
                        controller: correoController,
                        label: "Correo institucional",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 15),

                      _buildDropdown(),

                      const SizedBox(height: 15),

                      _buildTextField(
                          controller: contrasenaController,
                          label: "Contraseña",
                          icon: Icons.lock,
                          obscureText: true),

                      const SizedBox(height: 30),

                      ElevatedButton(
                        onPressed: isLoading ? null : _crearCuenta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text("Crear cuenta",
                                style: TextStyle(fontSize: 18)),
                      ),

                      const SizedBox(height: 15),

                      GestureDetector(
                        onTap: () {
                          if (!isLoading) {
                            Navigator.pushNamed(context, "/login");
                          }
                        },
                        child: const Text(
                          "¿Ya tienes una cuenta? Iniciar sesión",
                          style: TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00C853), Color(0xFFB2FF59)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<String>(
        initialValue: tipoUsuario,
        decoration: InputDecoration(
          hintText: 'Tipo de usuario',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.account_box_outlined),
        ),
        items: const [
          DropdownMenuItem(value: "Estudiante", child: Text("Estudiante")),
          DropdownMenuItem(value: "Chofer", child: Text("Chofer")),
          DropdownMenuItem(value: "Administrativo", child: Text("Administrativo")),
        ],
        onChanged: (value) => setState(() => tipoUsuario = value),
        validator: (value) =>
            value == null ? "Selecciona un tipo de usuario" : null,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Campo requerido" : null,
    );
  }
}
