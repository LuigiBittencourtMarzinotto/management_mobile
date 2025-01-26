import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:management_mobile/database/db.dart';
import 'package:management_mobile/models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_usu_nome TEXT, '
      '$_usu_cpf TEXT, '
      '$_usu_tipo TEXT, '
      '$_usu_senha TEXT)';

  static const String _tableName = 'sys_usuarios';
  static const String _id = 'id';
  static const String _usu_nome = 'usu_nome';
  static const String _usu_cpf = 'usu_cpf';
  static const String _usu_tipo = 'usu_tipo';
  static const String _usu_senha = 'usu_senha';

  Future<int> setUser(User user) async {
    final Database db = await getDatabase();
    user.usu_senha = hashPassword(user.usu_senha);
    final Map<String, dynamic> userMap = {
      'id': user.id,
      'usu_nome': user.usu_nome,
      'usu_cpf': user.usu_cpf,
      'usu_tipo': user.usu_tipo,
      'usu_senha': user.usu_senha,
    };

    return await db.insert(_tableName, userMap);
  }

  Future<List<Map<String, dynamic>>> validateUser(String cpf, String password) async {
    final Database db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$_usu_cpf = ? AND $_usu_senha = ?',
      whereArgs: [cpf, password],
      limit: 1,
    );

    return result;
  }

  Future<List<User>> getAllUsers() async {
    final Database db = await getDatabase();

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        *
      FROM sys_usuarios su
      WHERE su.usu_tipo = 0
    ''');

    List<User> users = [];

    for (var map in maps) {
      User user = User.fromMap(map);
      users.add(user);
    }

    return users;
  }


  Future<bool> validateUserCPF(String cpf) async {
    final Database db = await getDatabase();

    List<Map<String, dynamic>> result = await db.query(
      _tableName,
      where: '$_usu_cpf = ? ',
      whereArgs: [cpf],
    );

    return result.isNotEmpty;
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
