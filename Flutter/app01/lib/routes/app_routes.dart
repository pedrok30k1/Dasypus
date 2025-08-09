import 'package:app01/screens/profile_filho_screen.dart';
import 'package:app01/screens/profiles_filhos_screen.dart';
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/register_screend_filho.dart';

// Definição das rotas usando Routefly
class AppRoutes {
  // Rota principal
  static const String home = '/';

  // Rota de login
  static const String login = '/login';

  // Rota de cadastro
  static const String register = '/register';

  // Rota de dashboard
  static const String dashboard = '/dashboard';

  // Rota de perfil
  static const String profile = '/profile';

  // Rota de configurações
  static const String settings = '/settings';

  // Rota de cadastro de filho
  static const String registerFilho = '/registerFilho';

  //Rota de lista de filho
  static const String listeFilho = '/listeFilho';

  //Rota de Perfil de filho

  static const String profileFilho = '/profileFilho';

  // Configuração das rotas usando Routefly
  static final routes = {
    home: (context) => const LoginScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    dashboard: (context) => const DashboardScreen(),
    profile: (context) => const ProfileScreen(),
    registerFilho: (context) => const RegisterScreenFilho(),
    listeFilho: (context) => const ProfilesFilhosScreen(),
    profileFilho: (context) => const ProfileScreenFilho(),
    settings: (context) =>
        const Scaffold(body: Center(child: Text('Configurações'))),
  };

  // Método para navegar para uma rota
  static void navigateTo(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  // Método para navegar e substituir a rota atual
  static void navigateToReplacement(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  // Método para navegar e limpar o stack de rotas
  static void navigateToAndClear(BuildContext context, String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  // Método para voltar
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
