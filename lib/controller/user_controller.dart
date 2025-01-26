import 'package:management_mobile/database/dao/user_dao.dart';
import 'package:management_mobile/models/user.dart';

class UserController {
  UserDao userDao = UserDao();

  Future<dynamic> createUser(User user) async {
    var resultValidate = await userDao.validateUserCPF(user.usu_cpf);
    if(!resultValidate){
      return await userDao.setUser(user);
    }else{
      return false;
    }
  }

    Future<dynamic> getAllUsers() async {
    var result = await userDao.getAllUsers();
    return result;
  } 

  Future<dynamic> tryLogin(User user) async {
    String hashedPassword = userDao.hashPassword(user.usu_senha);
    return await userDao.validateUser(user.usu_cpf, hashedPassword);
  }
}
