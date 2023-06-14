// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:planejando_seu_dinheiro/components/appbar_widget.dart';

import 'package:planejando_seu_dinheiro/Database/database_sqlite.dart';
import 'package:planejando_seu_dinheiro/components/navbar_widget.dart';
import 'package:planejando_seu_dinheiro/modules/calculadora_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TabelaModel> tabela = [];
  var format = DateFormat('dd-MM-yyyy H:m:s');
  var actualDate = DateTime.now();
  var entrada = 0.0;
  var saida = 0.0;
  var atual = 0.0;
  var listaController = ScrollController();
  var quantityController = TextEditingController();
  var historicoController = TextEditingController();
  var _isLoading = true;
  var plusButtonTapped = false;
  var lessButtonTapped = false;

  @override
  void initState() {
    super.initState();
    _select();
    print(format.format(actualDate));
  }

  void _selecionarValores(
      [int id = 0,
      bool isEdit = false,
      bool isRetrive = false,
      double entrada = 0,
      double saida = 0]) async {
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: historicoController,
              ),
            )
          ],
        ),
        onConfirm: () {
          isEdit
              ? _editarRegistro(id, saida, entrada)
              : _adicionarRegistro(isRetrive);
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
          'categoria': 'Padrão',
          'data': format.format(data),
          'entrada': !isRetrive ? quantityController.text : 0,
          'saida': !isRetrive ? 0 : quantityController.text
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
            'entrada': entrada == 0 ? 0 : quantityController.text,
            'saida': saida == 0 ? 0 : quantityController.text,
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
      appBar: customAppBar('Budget', context),
      body: SafeArea(
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
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      atualFormatado,
                      style: const TextStyle(
                        fontSize: 23,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Entrada',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                  ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Saída',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
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
                  ListView.builder(
                    controller: listaController,
                    shrinkWrap: true,
                    itemCount: tabela.length,
                    itemBuilder: (context, index) {
                      var registro = tabela[index];
                      var saidoFormatado = NumberFormat.simpleCurrency(
                        locale: 'ptR-BR',
                        decimalDigits: 2,
                      ).format(registro.saida);
                      var entradaFormatado = NumberFormat.simpleCurrency(
                        locale: 'ptR-BR',
                        decimalDigits: 2,
                      ).format(registro.entrada);
                      return Card(
                        child: Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                            extentRatio: 0.4,
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                spacing: 1,
                                flex: 1,
                                onPressed: (context) {
                                  _selecionarValores(registro.id, true, false,
                                      registro.entrada, registro.saida);
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
                            leading: const Icon(Icons.money_off_csred_sharp),
                            title: Text(
                              registro.historico,
                              style: const TextStyle(fontFamily: 'Poppins'),
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
                    },
                  ),

                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * .1,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: lessButtonTapped
                  //             ? FloatingActionButton.extended(
                  //                 onPressed: () {
                  //                   setState(() {
                  //                     _selectQuantity(true);
                  //                   });
                  //                 },
                  //                 tooltip: 'Registrar gastos',
                  //                 label: const Text('Registrar gastos'),
                  //                 icon: const Icon(Icons.remove),
                  //               )
                  //             : FloatingActionButton(
                  //                 onPressed: () {
                  //                   setState(() {
                  //                     plusButtonTapped = false;
                  //                     lessButtonTapped = true;
                  //                   });
                  //                 },
                  //                 child: const Icon(Icons.remove),
                  //               ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: plusButtonTapped
                  //             ? FloatingActionButton.extended(
                  //                 onPressed: () {
                  //                   setState(() {
                  //                     _selectQuantity();
                  //                   });
                  //                 },
                  //                 tooltip: 'Adicionar dinheiro',
                  //                 label: const Text('Adicionar dinheiro'),
                  //                 icon: const Icon(Icons.add),
                  //               )
                  //             : FloatingActionButton(
                  //                 onPressed: () {
                  //                   setState(() {
                  //                     plusButtonTapped = true;
                  //                     lessButtonTapped = false;
                  //                   });
                  //                   print(plusButtonTapped);
                  //                 },
                  //                 child: const Icon(Icons.add),
                  //               ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: customNavBar(0),
      // bottomNavigationBar: Row(
      //   children: [
      //     Expanded(
      //       child: InkWell(
      //         onTap: () {
      //           _selecionarValores();
      //         },
      //         child: const SizedBox(
      //           height: 50,
      //           child: Icon(Icons.add),
      //         ),
      //       ),
      //     ),
      //     Expanded(
      //       child: InkWell(
      //         onTap: () {
      //           _selecionarValores(0, false, true);
      //         },
      //         child: const SizedBox(
      //           height: 50,
      //           child: Icon(Ionicons.remove),
      //         ),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class TabelaModel {
  int id;
  String historico;
  String categoria;
  String data;
  double entrada;
  double saida;
  TabelaModel({
    required this.id,
    required this.historico,
    required this.categoria,
    required this.data,
    required this.entrada,
    required this.saida,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'historico': historico,
      'categoria': categoria,
      'data': data,
      'entrada': entrada,
      'saida': saida,
    };
  }

  factory TabelaModel.fromMap(Map<String, dynamic> map) {
    return TabelaModel(
      id: map['id'] as int,
      historico: map['historico'] as String,
      categoria: map['categoria'] as String,
      data: map['data'] as String,
      entrada: map['entrada'] as double,
      saida: map['saida'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory TabelaModel.fromJson(String source) =>
      TabelaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TabelaModel(id: $id, historico: $historico, categoria: $categoria, data: $data, entrada: $entrada, saida: $saida)';
  }
}
