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
  String _frase = "";
  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController controller = TextEditingController();

  Future<void> speak(String text) async {
    await flutterTts.setLanguage("pt-BR"); // português
    await flutterTts.setPitch(1);          // tom da voz
    await flutterTts.setSpeechRate(0.9);   // velocidade
    await flutterTts.speak(text);
  }
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

  void _onCardTap(Map<String, dynamic> card) {
    print("Clicou no card: ${card['titulo']}");
    speak(card['descricao'] ?? '');
  }

  void _onAddButtonPressed() {
    // Aqui vai a função para adicionar novo card
    print("Botão + clicado");
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
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _cards.length,
        itemBuilder: (context, index) {
          final card = _cards[index];
          return GestureDetector(
            onTap: () => _onCardTap(card),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _hexToColor(card['tema_cor'] ?? "#CCCCCC"),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                card['titulo'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddButtonPressed,
        child: const Icon(Icons.add),
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
