import 'package:app01/routes/app_routes.dart';
import 'package:app01/services/api_service.dart';
import 'package:app01/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CardProfileScreen extends StatefulWidget {
  const CardProfileScreen({super.key});

  @override
  State<CardProfileScreen> createState() => _CardProfileScreenState();
}

class _CardProfileScreenState extends State<CardProfileScreen> {
  int? _userId;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  List<dynamic> _cards = [];
  final ApiService _apiService = ApiService();
  final FlutterTts flutterTts = FlutterTts();

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

      final userId = await SharedPrefsHelper.getCategoriaId();

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

      final resultado = await _apiService.getCardsByCategory(userId);

      if (resultado['status'] == 'success') {
        setState(() {
          _cards = resultado['data'];
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
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Erro ao carregar perfil: $e';
      });
    }
  }

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setPitch(1);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _onCardTap(Map<String, dynamic> card) {
    print("Clicou no card: ${card['titulo']}");
    speak(card['descricao'] ?? 'oi');
  }

  void _onAddButtonPressed() {
    AppRoutes.navigateTo(context, AppRoutes.registerCard);
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
      appBar: AppBar(title: const Text("Meus Cards")),
      body: _cards.isEmpty
          ? const Center(child: Text("Nenhum card encontrado."))
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.3,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                final cor = _hexToColor(card['tema_cor'] ?? "#CCCCCC");
                return InkWell(
                  onTap: () => _onCardTap(card),
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    color: cor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              card['titulo'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            if (card['descricao'] != null && card['descricao'].toString().isNotEmpty)
                              Text(
                                card['descricao'],
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
