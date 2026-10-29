import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../workers/presentation/screens/workers_list_screen.dart';
import '../../../traffic_light/presentation/screens/traffic_light_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@riocuarto.gov.ar');
  final _passwordController = TextEditingController(text: '••••••••');
  String _selectedRole = 'Administrador Municipal';

  final List<String> _roles = [
    'Administrador Municipal',
    'Inspector',
    'Desmalezador',
    'Responsable Vecinal',
    'Vecino',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Redirige al menú principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboardScreen(userRole: _selectedRole),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.grass, size: 72, color: AppTheme.primary),
                const SizedBox(height: 12),
                const Text(
                  'Gestión de Desmalezado',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryDark),
                ),
                const Text('Municipalidad de Río Cuarto', style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                DropdownButtonFormField<String>(
                  initialValue: _selectedRole,
                  decoration: const InputDecoration(labelText: 'Rol / Perfil de Acceso'),
                  items: _roles.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedRole = val);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Contraseña', prefixIcon: Icon(Icons.lock)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Ingresar al Sistema'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MainDashboardScreen extends StatelessWidget {
  final String userRole;

  const MainDashboardScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panel: $userRole'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Sesión activa como: $userRole\nSelecciona el módulo a consultar según tu tarea asignada.',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Gestión de Desmalezadores (HU-001)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WorkersListScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.traffic),
              label: const Text('Semáforo de Espacios Verdes (RF-08)'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade700),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TrafficLightScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
