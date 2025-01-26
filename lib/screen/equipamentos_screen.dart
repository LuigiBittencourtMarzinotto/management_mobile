import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:management_mobile/controller/equipamento_controller.dart';
import 'package:management_mobile/controller/equipamentos_users_controller.dart';
import 'package:management_mobile/controller/user_controller.dart';
import 'package:management_mobile/models/equipamento.dart';
import 'package:management_mobile/models/user.dart';
import 'package:management_mobile/screen/login_screen.dart';
import 'package:management_mobile/screen/qr_code_screen.dart';

class EquipamentosScreen extends StatefulWidget {
  static const String routeName = '/equipamentos';
  final int idUser;
  final int userTipo;
  const EquipamentosScreen({
    Key? key,
    required this.idUser,
    required this.userTipo,
  }) : super(key: key);

  @override
  State<EquipamentosScreen> createState() => _EquipamentosScreenState();
}

class _EquipamentosScreenState extends State<EquipamentosScreen>
    with WidgetsBindingObserver {
  EquipamentoController equipamentoController = EquipamentoController();
  EquipamentosUsersController equipamentosUsersController =
      EquipamentosUsersController();
  int _selectedIndex = 0;
  List<Equipamento> equipamentos = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadEquipamentos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadEquipamentos();
    }
  }

  void _loadEquipamentos() async {
    List<Equipamento> fetchedEquipamentos = [];
    if (widget.userTipo == 1) {
      fetchedEquipamentos = await equipamentoController.getAllEquipamentos();
    } else {
      fetchedEquipamentos =
          await equipamentoController.getEquipamentosByUser(widget.idUser);
    }
    setState(() {
      equipamentos = fetchedEquipamentos;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Indo para Equipamentos")),
      );
    } else if (index == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => QrCodeScannerScreen(
                  idUser: widget.idUser,
                  userTipo: widget.userTipo,
                  create: true,
                )),
        (Route<dynamic> route) {
          return route.settings.name != QrCodeScannerScreen.routeName;
        },
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Listagem de Equipamentos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: _buildListElements(),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      index: 0,
                      icon: Icons.home_rounded,
                    ),
                    if (widget.userTipo == 1)
                      _buildNavItem(
                        index: 1,
                        icon: Icons.add,
                        alwaysActiveBackground: true,
                        iconColor: Colors.white,
                        backColor: Colors.green[600],
                      ),
                    _buildNavItem(
                      index: 2,
                      icon: Icons.exit_to_app,
                      iconColor: const Color.fromARGB(162, 255, 17, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    Color? iconColor,
    Color? backColor,
    bool alwaysActiveBackground = false,
  }) {
    final bool isSelected = _selectedIndex == index;
    final Color backgroundColor = alwaysActiveBackground
        ? (backColor ?? Colors.white)
        : (isSelected ? (backColor ?? Colors.white) : Colors.transparent);
    final Color colorIcon =
        isSelected ? Colors.black : (iconColor ?? Colors.grey);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: colorIcon,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListElements() {
    if (equipamentos.isEmpty) {
      String mensagem = widget.userTipo == 0
          ? "Nenhum equipamento vinculado ao Usuário"
          : "Nenhum equipamento disponível cadastrado";

      return Center(
        child: Text(
          mensagem,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: equipamentos.length,
      itemBuilder: (context, index) {
        final equipamento = equipamentos[index];
        var data = equipamento.data_inventario != null
            ? DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(equipamento.data_inventario!))
            : "Sem data";
        bool dataValidada = equipamento.data_inventario != null
            ? _verificarDataInventario(equipamento.data_inventario!)
            : false;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    equipamento.eq_nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código: ${equipamento.eq_codigo}\nDescrição: ${equipamento.eq_descricao}\nData do Inventário: ${data}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    widget.userTipo == 1
                        ? Row(
                            children: [
                              Text(
                                "Vinculado: ",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                (equipamento.vinculado ?? false)
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: (equipamento.vinculado ?? false)
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: dataValidada
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dataValidada
                                        ? "Inventário válido"
                                        : "Novo inventário necessário",
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.userTipo == 1 && equipamento.vinculado == false
                    ? IconButton(
                        icon: const Icon(Icons.link),
                        onPressed: () {
                          _showLinkDialog(context, equipamento);
                        },
                      )
                    : Container(),
                if (widget.userTipo == 1 && equipamento.vinculado == false)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      _showDeleteDialog(
                          context, equipamento, equipamento.eq_codigo);
                    },
                  ),
                if (widget.userTipo == 0)
                  IconButton(
                    icon: const Icon(Icons.qr_code_2_outlined),
                    color: Colors.black,
                    iconSize: 40,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QrCodeScannerScreen(
                                idUser: widget.idUser,
                                userTipo: widget.userTipo,
                                create: false,
                                codigoEquipamento: equipamento.eq_codigo)),
                        (Route<dynamic> route) {
                          return route.settings.name !=
                              QrCodeScannerScreen.routeName;
                        },
                      );
                    },
                  ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  bool _verificarDataInventario(String dataInventario) {
    DateTime inventarioDate = DateTime.parse(dataInventario);
    DateTime currentDate = DateTime.now();

    DateTime inventarioDateWithoutTime =
        DateTime(inventarioDate.year, inventarioDate.month, inventarioDate.day);
    DateTime currentDateWithoutTime =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    int diasDeDiferenca =
        currentDateWithoutTime.difference(inventarioDateWithoutTime).inDays;

    if (diasDeDiferenca <= 30) {
      return true;
    } else {
      return false;
    }
  }

  void _showLinkDialog(BuildContext context, Equipamento equipamento) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Vincular Equipamento'),
          content: Text(
            'Você deseja vincular o equipamento "${equipamento.eq_nome}" ao usuário?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _showUserSelectionDialog(context, equipamento);
                Navigator.pop(context);
              },
              child: const Text('Vincular'),
            ),
          ],
        );
      },
    );
  }

  void _showUserSelectionDialog(
      BuildContext context, Equipamento equipamento) async {
    List<User> usuarios = await _getUsuarios();

    if (usuarios.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nenhum Usuário Cadastrado'),
            content: Text(
                'Não há usuários cadastrados para vincular o equipamento.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fechar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Selecione um Usuário'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    title: Text(usuario.usu_nome),
                    onTap: () {
                      Fluttertoast.showToast(
                        msg: "Carregando...",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      _linkEquipamentoToUser(equipamento, usuario);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      );
    }
  }

  void _showDeleteDialog(
      BuildContext context, Equipamento equipamento, String codigoEquipamento) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Deletar Equipamento'),
          content: Text(
            'Você tem certeza que deseja excluir o equipamento "${equipamento.eq_nome}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteEquipamento(equipamento, codigoEquipamento);
                Navigator.pop(context);
              },
              child: const Text('Deletar'),
            ),
          ],
        );
      },
    );
  }

  void _linkEquipamentoToUser(Equipamento equipamento, User usuario) async {
    var result = await equipamentosUsersController.setVinculoEquipamentoUser(
        equipamento, usuario);
    if (result != false) {
      Fluttertoast.showToast(
        msg: "Vinculado com sucesso!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      await Future.delayed(Duration(seconds: 3));
      setState(() {
        equipamento.vinculado = true;
      });
    }
  }

  void _deleteEquipamento(
      Equipamento equipamento, String codigoEquipamento) async {
    equipamentoController.updateEquipamentoAtivo(codigoEquipamento);
    setState(() {
      equipamentos.remove(equipamento);
    });

    print('Equipamento "${equipamento.eq_nome}" deletado.');
  }

  Future<List<User>> _getUsuarios() async {
    UserController userController = UserController();
    return await userController.getAllUsers();
  }
}
