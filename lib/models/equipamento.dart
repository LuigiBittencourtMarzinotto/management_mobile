class Equipamento {
  int? id;
  String eq_nome;
  String eq_codigo;
  String eq_descricao;
  String data_cadastro;
  bool? vinculado;
  String? data_inventario;


  Equipamento({
    this.id,
    required this.eq_nome,
    required this.eq_codigo,
    required this.eq_descricao,
    required this.data_cadastro,
    this.vinculado,
    this.data_inventario,
  });

  factory Equipamento.fromMap(Map<String, dynamic> map) {
    return Equipamento(
      id: map['id'],
      eq_nome: map['eq_nome'] ?? '', 
      eq_codigo: map['eq_codigo'] ?? '', 
      eq_descricao: map['eq_descricao'] ?? '', 
      data_cadastro: map['data_cadastro'] ?? '', 
      vinculado: map['vinculado'] == null ? null : map['vinculado'] == 'S', 
      data_inventario: map['data_inventario'] == null ? null : map['data_inventario'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eq_nome': eq_nome,
      'eq_codigo': eq_codigo,
      'eq_descricao': eq_descricao,
      'data_cadastro': data_cadastro,
      'vinculado': vinculado != null ? (vinculado! ? 'S' : 'N') : null, 
      'data_inventario': data_inventario != null ? data_inventario : null, 
    };
  }
}
