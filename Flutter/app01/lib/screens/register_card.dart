import 'package:app01/models/card.dart'; // Adicione este import
import 'package:app01/services/api_service.dart';
import 'package:app01/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CriarCardPage extends StatefulWidget {
  const CriarCardPage({Key? key}) : super(key: key);

  @override
  State<CriarCardPage> createState() => _CriarCardPageState();
}

class _CriarCardPageState extends State<CriarCardPage> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();
  final TextEditingController imagemUrlController = TextEditingController();
  final TextEditingController fonteController = TextEditingController();
 

  final ApiService _apiService = ApiService();
  int? userId;
  Color temaCor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SharedPrefsHelper.getCategoriaId();
    setState(() {
      userId = id;
    });
  }

  void escolherCor() {
    Color tempColor = temaCor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha a cor do tema'),
          content: BlockPicker(
            pickerColor: temaCor,
            onColorChanged: (color) {
              tempColor = color;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => temaCor = tempColor);
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            )
          ],
        );
      },
    );
  }

  void salvarCard() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado!')),
      );
      return;
    }

    final Card novoCard = Card(
      titulo: tituloController.text,
      descricao: descricaoController.text,
      imagemUrl: imagemUrlController.text.isNotEmpty ? imagemUrlController.text : null,
      temaCor: '#${temaCor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
      fonte: fonteController.text,
      idCategoria: userId!, // Use o ID da categoria salvo ou 0 se não existir
    );

    await _apiService.createCard(novoCard);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Card")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: "Título do Card"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(labelText: "Descrição (opcional)"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: imagemUrlController,
              decoration: const InputDecoration(labelText: "URL da Imagem"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fonteController,
              decoration: const InputDecoration(labelText: "Fonte (A, B, C...)"),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: escolherCor,
                  icon: const Icon(Icons.color_lens),
                  label: const Text("Escolher Cor"),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: temaCor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black26),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarCard,
              child: const Text("Salvar Card"),
            )
          ],
        ),
      ),
    );
  }
}
