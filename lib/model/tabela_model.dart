import 'dart:convert';

class TabelaModel {
  int id;
  String historico;
  String categoria;
  String data;
  double entrada;
  double saida;
  TabelaModel({
    required this.id,
    required this.historico,
    required this.categoria,
    required this.data,
    required this.entrada,
    required this.saida,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'historico': historico,
      'categoria': categoria,
      'data': data,
      'entrada': entrada,
      'saida': saida,
    };
  }

  factory TabelaModel.fromMap(Map<String, dynamic> map) {
    return TabelaModel(
      id: map['id'] as int,
      historico: map['historico'] as String,
      categoria: map['categoria'] as String,
      data: map['data'] as String,
      entrada: map['entrada'] as double,
      saida: map['saida'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TabelaModel.fromJson(String source) =>
      TabelaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TabelaModel(id: $id, historico: $historico, categoria: $categoria, data: $data, entrada: $entrada, saida: $saida)';
  }
}
