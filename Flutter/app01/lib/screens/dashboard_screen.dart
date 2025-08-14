import 'package:flutter/material.dart';
import '../utils/shared_prefs_helper.dart';
import '../routes/app_routes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? _userId;
  int? _counter;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Recuperar ID do usuário salvo
    final userId = await SharedPrefsHelper.getUserId();
    // Recuperar contador salvo
    final counter = await SharedPrefsHelper.getCounter();

    setState(() {
      _userId = userId;
      _counter = counter;
    });

    print('📖 User ID carregado: $_userId');

  }

  Future<void> _incrementCounter() async {
    final newCounter = (_counter ?? 0) + 1;
    final saved = await SharedPrefsHelper.saveCounter(newCounter);

    if (saved) {
      setState(() {
        _counter = newCounter;
      });
      print('✅ Contador incrementado: $_counter');
    }
  }

  Future<void> _clearUserData() async {
    final cleared = await SharedPrefsHelper.clear();
    if (cleared) {
      setState(() {
        _userId = null;
        _counter = null;
      });
      print('🗑️ Dados limpos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           

            // Botão para acessar perfil
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Perfil do Usuário',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visualize seus dados completos do perfil',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        AppRoutes.navigateTo(context, AppRoutes.profile);
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Ver Meu Perfil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Cadastro de filho',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visualize seus dados completos do perfil',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        AppRoutes.navigateTo(context, AppRoutes.registerFilho);
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('Cadastrar Filho'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
           const SizedBox(height: 8),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👤 Mostrar filhos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Visualize seus filhos',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        AppRoutes.navigateTo(context, AppRoutes.listeFilho);
                      },
                      icon: const Icon(Icons.person),
                      label: const Text('visializar filhos'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
