// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';

import 'package:planejando_seu_dinheiro/Database/database_sqlite.dart';
import 'package:planejando_seu_dinheiro/components/navbar_widget.dart';
import 'package:planejando_seu_dinheiro/components/variables.dart';
import 'package:rive/rive.dart';

import '../model/tabela_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabelaModel> tabela = [];
  List<String> items = ['Entrada', 'Saída'];
  var format = DateFormat('dd-MM-yyyy H:m:s');
  var actualDate = DateTime.now();
  var entrada = 0.0;
  var saida = 0.0;
  var atual = 0.0;
  var listaController = ScrollController();
  var quantityController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  var historicoController = TextEditingController();
  var categoriaController = TextEditingController();
  var _isLoading = true;
  var plusButtonTapped = false;
  var lessButtonTapped = false;
  String? dropDownvalue = 'Entrada';
  String formatedValue = '';

  @override
  void initState() {
    super.initState();
    _select();
    print(format.format(actualDate));
  }

  void _selecionarValores([
    int id = 0,
    bool isEdit = false,
    bool isRetrive = false,
    double entrada = 0,
    double saida = 0,
  ]) async {
    Get.defaultDialog(
        title: 'Seu registro',
        titleStyle: const TextStyle(fontFamily: 'Poppins'),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButton<String>(
                  value: dropDownvalue,
                  items: items
                      .map(
                        (item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(fontFamily: 'Montserrat'),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (item) => setState(() {
                    dropDownvalue = item;
                  }),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Histórico',
                    labelStyle: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  controller: historicoController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    labelStyle: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  controller: categoriaController,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefix: Text('R\$ '),
                    prefixStyle: TextStyle(fontFamily: 'Montserrat'),
                    labelStyle: TextStyle(fontFamily: 'Montserrat'),
                  ),
                  controller: quantityController,
                  // inputFormatters: [
                  //   ThousandsFormatter(
                  //     formatter: NumberFormat('###,###,###.##'),
                  //     allowFraction: true,
                  //   )
                  // ],
                ),
              ],
            ),
          );
        }),
        onConfirm: () {
          var value = quantityController.text;
          var newValue = value.replaceAll('.', '');
          formatedValue = newValue.replaceAll(RegExp(','), '.');
          isEdit
              ? _editarRegistro(id, saida, entrada)
              : _adicionarRegistro(dropDownvalue == 'Entrada' ? false : true);
          Get.back();
        });
  }

  void _select() async {
    final database = await DatabaseSqlite().openConnection();
    var regitro = await database.query('tabela');

    setState(() {
      tabela = regitro
          .map<TabelaModel>((result) => TabelaModel.fromMap(result))
          .toList();

      entrada = 0;
      saida = 0;

      for (var element in tabela) {
        entrada += element.entrada;
        saida += element.saida;
      }

      atual = entrada - saida;

      tabela.sort((a, b) => b.data.compareTo(a.data));
      print(tabela);

      _isLoading = false;
      print(_isLoading);
    });
  }

  void _adicionarRegistro([bool isRetrive = false]) async {
    final database = await DatabaseSqlite().openConnection();
    var data = DateTime.now();
    setState(() {
      database.insert(
        'tabela',
        {
          'historico': historicoController.text,
          'categoria': categoriaController.text,
          'data': format.format(data),
          'entrada': !isRetrive ? double.parse(formatedValue) : 0,
          'saida': !isRetrive ? 0 : double.parse(formatedValue)
        },
      );
    });
    _select();
  }

  void _deletarRegistro(int id) async {
    final database = await DatabaseSqlite().openConnection();
    setState(() {
      database.delete('tabela', where: 'id = ?', whereArgs: [id]);
    });
    _select();
  }

  void _editarRegistro(int id, double saida, double entrada) async {
    final database = await DatabaseSqlite().openConnection();
    var data = DateTime.now();

    setState(() {
      database.update(
          'tabela',
          {
            'entrada': entrada == 0 ? 0 : double.parse(quantityController.text),
            'saida': saida == 0 ? 0 : double.parse(quantityController.text),
            'historico': historicoController.text,
            'data': format.format(data),
          },
          where: 'id = ?',
          whereArgs: [id]);
    });
    _select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedOpacity(
        opacity: _isLoading ? 0 : 1,
        duration: const Duration(milliseconds: 1000),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              if (_isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var atualFormatado = NumberFormat.simpleCurrency(
                  locale: 'pt-BR',
                  decimalDigits: 2,
                ).format(atual);
                var entradaFormatado = NumberFormat.simpleCurrency(
                  locale: 'pt-BR',
                  decimalDigits: 2,
                ).format(entrada);

                var saidaFormatado = NumberFormat.simpleCurrency(
                  locale: 'pt-BR',
                  decimalDigits: 2,
                ).format(saida);

                return ListView(
                  controller: listaController,
                  children: [
                    Container(
                      color: Colors.amber,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Total disponível:',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      atualFormatado,
                                      style: const TextStyle(
                                        fontSize: 23,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    _selecionarValores();
                                  },
                                  icon: const Icon(Icons.add),
                                  iconSize: 30,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Entrada',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 17,
                                              color: notThatBlack),
                                        ),
                                        Text(
                                          entradaFormatado,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Saída',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 17,
                                            color: notThatBlack,
                                          ),
                                        ),
                                        Text(
                                          saidaFormatado,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 20,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          color: Colors.amber,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 45),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          height: tabela.isEmpty
                              ? MediaQuery.of(context).size.height * .5
                              : null,
                          child: ListView.builder(
                            controller: listaController,
                            shrinkWrap: true,
                            itemCount: tabela.isEmpty ? 1 : tabela.length,
                            itemBuilder: (context, index) {
                              if (tabela.isEmpty) {
                                return Column(
                                  children: [
                                    const Text(
                                      'Nenhum registro ainda...',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18,
                                        color: notThatBlack,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                      child: const RiveAnimation.asset(
                                          'assets/rive/cat.riv'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .8,
                                      child: const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Registra aí suas financias!',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 16,
                                                color: notThatBlack,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'É só apertar no botão de adicionar!',
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 16,
                                                color: Colors.red,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                var registro = tabela[index];
                                var saidoFormatado =
                                    NumberFormat.simpleCurrency(
                                  locale: 'ptR-BR',
                                  decimalDigits: 2,
                                ).format(registro.saida);
                                var entradaFormatado =
                                    NumberFormat.simpleCurrency(
                                  locale: 'ptR-BR',
                                  decimalDigits: 2,
                                ).format(registro.entrada);
                                return Card(
                                  child: Slidable(
                                    key: const ValueKey(0),
                                    endActionPane: ActionPane(
                                      extentRatio: 0.4,
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          spacing: 1,
                                          flex: 1,
                                          onPressed: (context) {
                                            _selecionarValores(
                                                registro.id,
                                                true,
                                                false,
                                                registro.entrada,
                                                registro.saida);
                                          },
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'Editar',
                                        ),
                                        SlidableAction(
                                          spacing: 1,
                                          flex: 1,
                                          onPressed: (context) {
                                            _deletarRegistro(registro.id);
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'Deletar',
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                          Icons.money_off_csred_sharp),
                                      title: Text(
                                        registro.historico,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins'),
                                      ),
                                      subtitle: Text(registro.data),
                                      trailing: Text(
                                        registro.entrada == 0
                                            ? saidoFormatado
                                            : entradaFormatado,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: registro.entrada == 0
                                                ? Colors.red
                                                : Colors.green),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: customNavBar(0),
    );
  }
}
