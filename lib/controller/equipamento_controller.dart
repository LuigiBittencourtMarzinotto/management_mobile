import 'package:management_mobile/database/dao/equipamento_dao.dart';
import 'package:management_mobile/models/equipamento.dart';

class EquipamentoController {
  EquipamentoDao equipamentoDao = EquipamentoDao();

  Future<dynamic> getEquipamentosByUser(int user_id) async {
    var result = await equipamentoDao.getEquipamentosByUser(user_id);
    return result;
  }
  Future<dynamic> getAllEquipamentos() async {
    var result = await equipamentoDao.getAllEquipamentos();
    return result;
  }
    Future<dynamic> getEquipamentosByCodigo(Equipamento equipamento) async  {
    var result = await equipamentoDao.getEquipamentoByCodigo(equipamento);
    return result;

  }

  Future<dynamic> setEquipamento(Equipamento equipamento) async {
    var result = await equipamentoDao.setEquipamento(equipamento);
    return result;
  }

    Future<dynamic> updateEquipamentoAtivo(String codigoEquipamento) async {
    var result = await equipamentoDao.updateEquipamentoAtivo(codigoEquipamento);
    return result;
  }

}
