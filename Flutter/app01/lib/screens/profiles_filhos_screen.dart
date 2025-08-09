import 'package:app01/routes/app_routes.dart';
import 'package:app01/services/api_service.dart';
import 'package:app01/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class ProfilesFilhosScreen extends StatefulWidget {
  const ProfilesFilhosScreen({super.key});

  @override
  State<ProfilesFilhosScreen> createState() => _ProfilesFilhosScreenState();
}

class _ProfilesFilhosScreenState extends State<ProfilesFilhosScreen> {
  int? _userId;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<dynamic> _childrenList = [];
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadUserFilho();
  }

  Future<void> _loadUserFilho() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      final userId = await SharedPrefsHelper.getUserId();

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = 'ID do usuário não encontrado. Faça login novamente.';
        });
        return;
      }

      setState(() {
        _userId = userId;
      });

      final resultado = await _apiService.getUserChildren(userId);

      if (resultado['status'] == 'success') {
        dynamic rawData = resultado['data'];
        List<dynamic> filhos = [];

        if (rawData is List) {
          filhos = rawData;
        } else if (rawData is Map) {
          filhos = [rawData];
        }

        setState(() {
          _childrenList = filhos;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = resultado['message'] ?? 'Erro ao carregar perfil';
        });
      }
    } catch (e) {
      print('❌ Erro ao carregar perfil: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar perfil: $e';
      });
    }
  }

  void _onChildTap(Map<String, dynamic> child) {
    // Aqui você pode implementar a ação que quiser
    // Por exemplo, navegar para outro perfil, selecionar, ativar, etc.
    print('👦 Tocou no filho: ${child['nome']}');
    var saveUserFilhoId = SharedPrefsHelper.saveUserFilhoId(child['id']);
    AppRoutes.navigateTo(context, AppRoutes.listaCategoria);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Selecionado: ${child['nome']}')));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasError) {
      return Scaffold(body: Center(child: Text(_errorMessage)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Perfis dos Filhos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _childrenList.map((child) {
            return GestureDetector(
              onTap: () => _onChildTap(child),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      _getInitials(child['nome']),
                      style: const TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    child['nome'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getInitials(String? nome) {
    if (nome == null || nome.isEmpty) return "?";
    List<String> partes = nome.split(" ");
    if (partes.length == 1) return partes[0][0].toUpperCase();
    return (partes[0][0] + partes[1][0]).toUpperCase();
  }
}
