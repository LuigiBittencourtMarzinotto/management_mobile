import 'package:management_mobile/database/dao/equipamento_dao.dart';
import 'package:management_mobile/database/dao/equipamento_user_dao.dart';
import 'package:management_mobile/models/equipamento.dart';
import 'package:management_mobile/models/user.dart';

class EquipamentosUsersController {
  EquipamentoUserDao equipamentoUserDao = EquipamentoUserDao();
  EquipamentoDao equipamentoDao = EquipamentoDao();

  Future<dynamic> updateVinculoEquipamentoUser(
      Equipamento equipamento) async {
    var result = await equipamentoUserDao.updateLastInventory(equipamento);
    return result;
  }


  Future<dynamic> setVinculoEquipamentoUser(
      Equipamento equipamento, User usuario) async {
    var result =
        await equipamentoUserDao.setEquipamentoUser(equipamento, usuario);
    return result;
  }
}
