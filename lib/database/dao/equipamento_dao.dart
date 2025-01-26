import 'package:management_mobile/database/db.dart';
import 'package:management_mobile/models/equipamento.dart';
import 'package:sqflite/sqflite.dart';

class EquipamentoDao {
  static const String tableSql = '''
    CREATE TABLE $_tableName (
      $_id INTEGER PRIMARY KEY, 
      $_eq_nome TEXT NOT NULL, 
      $_eq_codigo TEXT UNIQUE NOT NULL, 
      $_eq_descricao TEXT NOT NULL, 
      $_data_cadastro TEXT NOT NULL,
      $_eq_ativo TEXT NOT NULL DEFAULT 'S'
    )
  ''';

  static const String _tableName = 'equipamentos';
  static const String _id = 'id';
  static const String _eq_nome = 'eq_nome';
  static const String _eq_codigo = 'eq_codigo';
  static const String _eq_descricao = 'eq_descricao';
  static const String _data_cadastro = 'data_cadastro';
  static const String _eq_ativo = 'eq_ativo';

  Future<bool> setEquipamento(Equipamento equipamento) async {
    final Database db = await getDatabase();

    final Map<String, dynamic> equipamentoMap = {
      'eq_nome': equipamento.eq_nome,
      'eq_codigo': equipamento.eq_codigo,
      'eq_descricao': equipamento.eq_descricao,
      'data_cadastro': equipamento.data_cadastro,
    };

    try {
      await db.insert(_tableName, equipamentoMap);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Equipamento>> getAllEquipamentos() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        e.id, 
        e.eq_nome, 
        e.eq_codigo, 
        e.eq_descricao, 
        eu.ultima_leitura as data_inventario,
        CASE 
          WHEN eu.equipamento_id IS NOT NULL THEN 'S'
          ELSE 'N'
        END AS vinculado
      FROM equipamentos e
      LEFT JOIN equipamentos_users eu ON e.id = eu.equipamento_id
      WHERE e.eq_ativo = 'S'
    ''');

    List<Equipamento> equipamentos = [];

    for (var map in maps) {
      bool? vinculado = map['vinculado'] == 'S' ? true : false;
      Equipamento equipamento = Equipamento.fromMap(map);
      equipamento.vinculado = vinculado;

      equipamentos.add(equipamento);
    }

    return equipamentos;
  }

  Future<List<Equipamento>> getEquipamentoByCodigo(
      Equipamento equipamento) async {
    final Database db = await getDatabase();
    var sqlGet = await db.rawQuery(
      'SELECT * FROM equipamentos WHERE eq_codigo = ?',
      [equipamento.eq_codigo],
    );

    return sqlGet.map((map) => Equipamento.fromMap(map)).toList();
  }

  Future<List<Equipamento>> getEquipamentosByUser(int userId) async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT 
      e.id, e.eq_nome, e.eq_codigo, e.eq_descricao, eu.ultima_leitura as data_inventario
    FROM equipamentos e
    LEFT JOIN equipamentos_users eu ON e.id = eu.equipamento_id
    WHERE eu.user_id = ? AND e.eq_ativo = 'S'
  ''', [userId]);

    List<Equipamento> equipamentos = [];
    for (var map in maps) {
      equipamentos.add(Equipamento.fromMap(map));
    }
    return equipamentos;
  }

  Future<bool> updateEquipamentoAtivo(String codigoEquipamento) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> updateMap = {
      'eq_ativo': 'N',
    };

    try {
      int affectedRows = await db.update(
        _tableName,
        updateMap,
        where: 'eq_codigo = ?',
        whereArgs: [codigoEquipamento],
      );
      return affectedRows > 0;
    } catch (e) {
      print("Erro ao atualizar o equipamento: $e");
      return false;
    }
  }
}
