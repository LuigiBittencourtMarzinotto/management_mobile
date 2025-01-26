class User {
  int? id; 
  String usu_nome;
  String usu_cpf;
  String usu_senha;
  String usu_tipo;


  User({
    this.id,
    required this.usu_nome,
    required this.usu_cpf,
    required this.usu_senha,
    required this.usu_tipo,
  });

    factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      usu_nome: map['usu_nome'] ?? '', 
      usu_cpf: map['usu_cpf'] ?? '', 
      usu_senha: map['usu_senha'] ?? '', 
      usu_tipo: map['usu_tipo'] ?? '', 
    );
  }

}
