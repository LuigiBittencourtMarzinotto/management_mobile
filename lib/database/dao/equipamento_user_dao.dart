import 'package:management_mobile/database/db.dart';
import 'package:management_mobile/models/equipamento.dart';
import 'package:management_mobile/models/user.dart';
import 'package:sqflite/sqflite.dart';

class EquipamentoUserDao {
  static const String tableSql = '''
    CREATE TABLE $_tableName (
      $_link_id INTEGER PRIMARY KEY AUTOINCREMENT, 
      $_user_id INTEGER NOT NULL, 
      $_equipment_id INTEGER NOT NULL, 
      $_data_vinculo TEXT NOT NULL, 
      $_ultima_leitura TEXT, 
      FOREIGN KEY($_user_id) REFERENCES users($_user_id),
      FOREIGN KEY($_equipment_id) REFERENCES equipamentos($_equipment_id)
    )
  ''';

  static const String _tableName = 'equipamentos_users';
  static const String _link_id = 'link_id';
  static const String _user_id = 'user_id';
  static const String _equipment_id = 'equipamento_id';
  static const String _data_vinculo = 'data_vinculo';
  static const String _ultima_leitura = 'ultima_leitura';

  Future<int> setEquipamentoUser(Equipamento equipamento, User usuario) async {
    final Database db = await getDatabase();

    final Map<String, dynamic> equipamentoUserMap = {
      _user_id: usuario.id,
      _equipment_id: equipamento.id,
      _data_vinculo: DateTime.now().toIso8601String(), 
      _ultima_leitura: null,  
    };

    return await db.insert(_tableName, equipamentoUserMap);
  }

  Future<int> updateLastInventory(Equipamento equipamento) async {
    final Database db = await getDatabase();
    
    final Map<String, dynamic> updateMap = {
      _ultima_leitura: equipamento.data_inventario,  
    };

    return await db.update(
      _tableName,
      updateMap,
      where: '$_equipment_id = ?',
      whereArgs: [equipamento.id],
    );
  }
}
