import 'package:app01/routes/app_routes.dart';
import 'package:app01/services/api_service.dart';
import 'package:app01/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';

class CategoriaProfileScreen extends StatefulWidget {
  const CategoriaProfileScreen({super.key});

  @override
  State<CategoriaProfileScreen> createState() => _CategoriaProfileScreenState();
}

class _CategoriaProfileScreenState extends State<CategoriaProfileScreen> {
  int? _userId;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<Map<String, dynamic>> _categorias = [];
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

      final userId = await SharedPrefsHelper.getUserFilhoId();

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

      final resultado = await _apiService.getCategoriesByUser(userId);

      if (resultado['status'] == 'success') {
        List<dynamic> dados = resultado['data'];
        setState(() {
          _categorias = List<Map<String, dynamic>>.from(dados);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _errorMessage = resultado['message'] ?? 'Erro ao carregar categorias';
        });
      }
    } catch (e) {
      print('❌ Erro ao carregar perfil: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar categorias: $e';
      });
    }
  }

  void _onCategoriaTap(Map<String, dynamic> categoria) {
    print('Categoria clicada: ${categoria['nome']}');
    SharedPrefsHelper.saveCategoriaId(categoria['id']);
    AppRoutes.navigateTo(context, AppRoutes.listaCard);
  }

  void _onAdicionarCategoria() {
    print('Botão + clicado');
    AppRoutes.navigateTo(context, AppRoutes.criarCategoria);
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
      appBar: AppBar(title: const Text('Categorias')),
      body: Column(
        children: [
          Expanded(
            child: _categorias.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Nenhuma categoria encontrada para este usuário.',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      final categoria = _categorias[index];
                      final cor = categoria['tema_cor'] != null
                          ? _hexToColor(categoria['tema_cor'])
                          : Colors.grey[300];

                      return GestureDetector(
                        onTap: () => _onCategoriaTap(categoria),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            categoria['nome'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _onAdicionarCategoria,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Categoria'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Converte string de cor "#RRGGBB" para Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) {
      hex = "FF$hex";
    }
    return Color(int.parse(hex, radix: 16));
  }
}
