class Card {
  final int? id;
  final String titulo;
  final String descricao;
  final String? imagemUrl;
  final String? temaCor;
  final int idCategoria;

  Card({
    this.id,
    required this.titulo,
    required this.descricao,
    this.imagemUrl,
    this.temaCor,
    required this.idCategoria,
  });

  // Convert Card to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'imagem_url': imagemUrl,
      'tema_cor': temaCor,
      'id_categoria': idCategoria,
    };
  }

  // Create Card from JSON
  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      imagemUrl: json['imagem_url'],
      temaCor: json['tema_cor'],
      idCategoria: json['id_categoria'],
    );
  }

  // Create a copy of Card with some fields changed
  Card copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? imagemUrl,
    String? temaCor,
    int? idCategoria,
  }) {
    return Card(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      temaCor: temaCor ?? this.temaCor,
      idCategoria: idCategoria ?? this.idCategoria,
    );
  }

  @override
  String toString() {
    return 'Card(id: $id, titulo: $titulo, descricao: $descricao, imagemUrl: $imagemUrl, temaCor: $temaCor, idCategoria: $idCategoria)';
  }
}
