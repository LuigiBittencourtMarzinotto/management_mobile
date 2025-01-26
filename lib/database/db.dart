import 'package:management_mobile/database/dao/equipamento_dao.dart';
import 'package:management_mobile/database/dao/equipamento_user_dao.dart';
import 'package:management_mobile/database/dao/user_dao.dart';
import 'package:management_mobile/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'management.db');

  return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async {
    await db.execute(UserDao.tableSql);
    await db.execute(EquipamentoDao.tableSql);
    await db.execute(EquipamentoUserDao.tableSql);    
  });
}
