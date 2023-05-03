// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:sqflite/sqflite.dart';

import 'package:planejando_seu_dinheiro/Database/database_sqlite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DinheiroModel> dinheiros = [];
  List<GastosModel> gastos = [];
  var quantityController = TextEditingController();
  var categoriaController = TextEditingController();
  var _isLoading = true;
  var plusButtonTapped = false;
  var lessButtonTapped = false;

  @override
  void initState() {
    super.initState();
    _select();
  }

  Future<void> _selectQuantity([bool isRetrive = false]) async {
    Get.defaultDialog(
        title: 'Selecione a quantidade',
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                decoration: const InputDecoration(prefix: Text('R\$ ')),
                controller: quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  ThousandsFormatter(
                    formatter: NumberFormat('###,###,###.##'),
                    allowFraction: true,
                  )
                ],
              ),
            ),
            isRetrive
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: categoriaController,
                    ),
                  )
                : SizedBox(),
          ],
        ),
        onConfirm: () {
          isRetrive ? _retirarCapital() : _adicionarCapital();
          Get.back();
        });
  }

  void _select() async {
    final database = await DatabaseSqlite().openConnection();
    var regitroAtual = await database.query('psd');
    var regitroDeGastos = await database.query('gastos');
    print(regitroAtual);

    setState(() {
      dinheiros = regitroAtual
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      print(regitroDeGastos);
      if (regitroDeGastos.isNotEmpty) {
        gastos = regitroDeGastos
            .map<GastosModel>((result) => GastosModel.fromMap(result))
            .toList();
      }

      _isLoading = false;
      print(_isLoading);
    });
  }

  void _adicionarCapital() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      double total = double.parse(
            dinheiros[0].dinheiroatual.toStringAsFixed(2),
          ) +
          double.parse(quantityController.text);
      double totalAdicionado =
          dinheiros[0].dinheirorecebido + double.parse(quantityController.text);

      database.update(
        'psd',
        {'dinheiroatual': total},
        where: 'dinheiroatual = ?',
        whereArgs: [dinheiros[0].dinheiroatual],
      );
      database.update(
        'psd',
        {'dinheirorecebido': totalAdicionado},
        where: 'dinheirorecebido = ?',
        whereArgs: [dinheiros[0].dinheirorecebido],
      );
      print(dinheiros[0].dinheiroatual);
    });
    _select();
  }

  void _retirarCapital() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      double total = double.parse(
            dinheiros[0].dinheiroatual.toStringAsFixed(2),
          ) -
          double.parse(quantityController.text);
      double totalRetirado = gastos.isNotEmpty
          ? dinheiros[0].dinheirototalgasto +
              double.parse(quantityController.text)
          : double.parse(quantityController.text);
      database.update(
        'psd',
        {'dinheiroatual': total, 'dinheirototalgasto': totalRetirado},
        where: 'dinheiroatual = ?',
        whereArgs: [dinheiros[0].dinheiroatual],
      );
      database.insert(
        'gastos',
        {
          'categoria': categoriaController.text,
          'dinheirogasto': double.parse(quantityController.text)
        },
      );
    });
    _select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var dinheiroAtualFormatado = NumberFormat.simpleCurrency(
                locale: 'pt-BR',
                decimalDigits: 2,
              ).format(dinheiros[0].dinheiroatual);
              var dinheiroRecebidoFormatado = NumberFormat.simpleCurrency(
                locale: 'pt-BR',
                decimalDigits: 2,
              ).format(dinheiros[0].dinheirorecebido);
              var dinheiroGastoTotalFormatado = 'R\$ 0,00';
              var dinheiroGastoFormatado = 'R\$ 0,00';

              dinheiroGastoTotalFormatado = NumberFormat.simpleCurrency(
                locale: 'ptR-BR',
                decimalDigits: 2,
              ).format(dinheiros[0].dinheirototalgasto);

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: Text(
                                dinheiroAtualFormatado,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
                                          'Recebido',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          dinheiroRecebidoFormatado,
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
                                          'Gastos',
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          '- $dinheiroGastoTotalFormatado',
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
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .67,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: gastos.length,
                        itemBuilder: (b, i) {
                          if (gastos.isEmpty) {
                            return const SizedBox();
                          } else {
                            var gasto = gastos[i];
                            dinheiroGastoFormatado =
                                NumberFormat.simpleCurrency(
                              locale: 'ptR-BR',
                              decimalDigits: 2,
                            ).format(gasto.dinheirogasto);
                            return ListTile(
                              leading: Icon(Icons.add_reaction),
                              title: Text(gasto.categoria),
                              trailing: Text(dinheiroGastoFormatado),
                            );
                            // return Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     Icon(Icons.add_reaction_rounded),
                            //     Text(gasto.categoria),
                            //     Text(dinheiroGastoFormatado),
                            //   ],
                            // );
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: lessButtonTapped
                                ? FloatingActionButton.extended(
                                    onPressed: () {
                                      setState(() {
                                        _selectQuantity(true);
                                      });
                                    },
                                    tooltip: 'Registrar gastos',
                                    label: const Text('Registrar gastos'),
                                    icon: const Icon(Icons.remove),
                                  )
                                : FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        plusButtonTapped = false;
                                        lessButtonTapped = true;
                                      });
                                    },
                                    child: const Icon(Icons.remove),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: plusButtonTapped
                                ? FloatingActionButton.extended(
                                    onPressed: () {
                                      setState(() {
                                        _selectQuantity();
                                      });
                                    },
                                    tooltip: 'Adicionar dinheiro',
                                    label: const Text('Adicionar dinheiro'),
                                    icon: const Icon(Icons.add),
                                  )
                                : FloatingActionButton(
                                    onPressed: () {
                                      setState(() {
                                        plusButtonTapped = true;
                                        lessButtonTapped = false;
                                      });
                                      print(plusButtonTapped);
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class DinheiroModel {
  int id;
  double dinheiroatual;
  double dinheirorecebido;
  double dinheirototalgasto;
  DinheiroModel({
    required this.id,
    required this.dinheiroatual,
    required this.dinheirorecebido,
    required this.dinheirototalgasto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dinheiroatual': dinheiroatual,
      'dinheirorecebido': dinheirorecebido,
      'dinheirototalgasto': dinheirototalgasto,
    };
  }

  factory DinheiroModel.fromMap(Map<String, dynamic> map) {
    return DinheiroModel(
      id: map['id'] as int,
      dinheiroatual: map['dinheiroatual'] as double,
      dinheirorecebido: map['dinheirorecebido'] as double,
      dinheirototalgasto: map['dinheirototalgasto'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DinheiroModel.fromJson(String source) =>
      DinheiroModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DinheiroModel(id: $id, dinheiroatual: $dinheiroatual, dinheirorecebido: $dinheirorecebido, dinheirototalgasto: $dinheirototalgasto)';
  }
}

class GastosModel {
  String categoria;
  double dinheirogasto;
  GastosModel({
    required this.categoria,
    required this.dinheirogasto,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categoria': categoria,
      'dinheirogasto': dinheirogasto,
    };
  }

  factory GastosModel.fromMap(Map<String, dynamic> map) {
    return GastosModel(
      categoria: map['categoria'] as String,
      dinheirogasto: map['dinheirogasto'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory GastosModel.fromJson(String source) =>
      GastosModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'GastosModel(categoria: $categoria, dinheirogasto: $dinheirogasto)';
}
