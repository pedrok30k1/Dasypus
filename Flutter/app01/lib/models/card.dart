class Card {
  final int? id;
  final String pergunta;
  final String resposta;
  final int idCategoria;
  final String? dificuldade;

  Card({
    this.id,
    required this.pergunta,
    required this.resposta,
    required this.idCategoria,
    this.dificuldade,
  });

  // Convert Card to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pergunta': pergunta,
      'resposta': resposta,
      'id_categoria': idCategoria,
      'dificuldade': dificuldade,
    };
  }

  // Create Card from JSON
  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      pergunta: json['pergunta'],
      resposta: json['resposta'],
      idCategoria: json['id_categoria'],
      dificuldade: json['dificuldade'],
    );
  }

  // Create a copy of Card with some fields changed
  Card copyWith({
    int? id,
    String? pergunta,
    String? resposta,
    int? idCategoria,
    String? dificuldade,
  }) {
    return Card(
      id: id ?? this.id,
      pergunta: pergunta ?? this.pergunta,
      resposta: resposta ?? this.resposta,
      idCategoria: idCategoria ?? this.idCategoria,
      dificuldade: dificuldade ?? this.dificuldade,
    );
  }

  @override
  String toString() {
    return 'Card(id: $id, pergunta: $pergunta, idCategoria: $idCategoria, dificuldade: $dificuldade)';
  }
}
