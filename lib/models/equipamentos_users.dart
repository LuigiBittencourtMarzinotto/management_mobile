class EquipamentosUsers {
  int? id;
  String user_id;
  String equipamento_id;
  String data_viculo;
  String ultima_leitura;

  EquipamentosUsers({
    this.id,
    required this.user_id,
    required this.equipamento_id,
    required this.data_viculo,
    required this.ultima_leitura,
  });

  factory EquipamentosUsers.fromMap(Map<String, dynamic> map) {
    return EquipamentosUsers(
      id: map['id'],
      user_id: map['user_id'] ?? '', 
      equipamento_id: map['equipamento_id'] ?? '', 
      data_viculo: map['data_viculo'] ?? '', 
      ultima_leitura: map['ultima_leitura'] ?? '', 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'equipamento_id': equipamento_id,
      'data_viculo': data_viculo,
      'ultima_leitura': ultima_leitura, 
    };
  }
}
