import 'package:app01/models/categoria.dart';
import 'package:app01/services/api_service.dart';
import 'package:app01/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CriarCategoriaPage extends StatefulWidget {
  const CriarCategoriaPage({Key? key}) : super(key: key);

  @override
  State<CriarCategoriaPage> createState() => _CriarCategoriaPageState();
}

class _CriarCategoriaPageState extends State<CriarCategoriaPage> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController fotoUrlController = TextEditingController();
  final ApiService _apiService = ApiService();
  int? userId;
  Color temaCor = Colors.red;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final id = await SharedPrefsHelper.getUserFilhoId();
    setState(() {
      userId = id;
    });
  }

  void escolherCor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha a cor do tema'),
          content: BlockPicker(
            pickerColor: temaCor,
            onColorChanged: (color) {
              setState(() => temaCor = color);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            )
          ],
        );
      },
    );
  }

  void salvarCategoria() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não encontrado!'))
      );
      return;
    }
    final Categoria categoria = Categoria(
      nome: nomeController.text,
      idUsuario: userId!,
      fotoUrl: fotoUrlController.text.isNotEmpty ? fotoUrlController.text : null,
      temaCor: '#${temaCor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
    );
    await _apiService.createCategory(categoria);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Categoria")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome da Categoria"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fotoUrlController,
              decoration: const InputDecoration(labelText: "Foto URL (opcional)"),
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
              onPressed: salvarCategoria,
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
