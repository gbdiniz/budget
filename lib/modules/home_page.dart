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
  var quantityController = TextEditingController();
  var _isLoading = true;

  @override
  void initState() {
    super.initState();
    _select();
  }

  Future<void> _selectQuantity() async {
    Get.defaultDialog(
        title: 'Selecione a quantidade',
        content: Padding(
          padding: EdgeInsets.all(8),
          child: TextFormField(
            decoration: InputDecoration(prefix: Text('R\$ ')),
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
        onConfirm: () {
          _addMoney();
          Get.back();
        });
  }

  void _select() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    print(result);

    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      _isLoading = false;
    });
  }

  void _addMoney() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      double total = double.parse(
            dinheiros[0].dinheiroAtual.toStringAsFixed(2),
          ) +
          double.parse(quantityController.text);

      database.update(
        'psd',
        {'dinheiroatual': total},
        where: 'dinheiroatual = ?',
        whereArgs: [dinheiros[0].dinheiroAtual],
      );
      database.update(
        'psd',
        {'dinheirorecebido': total},
        where: 'dinheirorecebido = ?',
        whereArgs: [dinheiros[0].dinheiroAtual],
      );
      print(dinheiros[0].dinheiroAtual);
    });
    _select();
  }

  void _tirarDinheiro() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      database.update(
        'psd',
        {'dinheiroatual': 0.00},
        where: 'dinheiroatual = ?',
        whereArgs: [dinheiros[0].dinheiroAtual],
      );
    });
    _select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var dinheiroFormatado = NumberFormat.simpleCurrency(
                locale: 'pt-BR',
                decimalDigits: 2,
              ).format(dinheiros[0].dinheiroAtual);

              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Text(
                        dinheiroFormatado,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recebido',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '+ R\$11,00',
                                  style: TextStyle(
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
                                Text(
                                  'Gastos',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  '- R\$11,00',
                                  style: TextStyle(
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
                  )
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _tirarDinheiro();
                  },
                  child: const Icon(Icons.remove),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    _selectQuantity();
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DinheiroModel {
  double dinheiroAtual;
  double dinheiroRecebido;
  DinheiroModel({
    required this.dinheiroAtual,
    required this.dinheiroRecebido,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dinheiroAtual': dinheiroAtual,
      'dinheiroRecebido': dinheiroRecebido,
    };
  }

  factory DinheiroModel.fromMap(Map<String, dynamic> map) {
    return DinheiroModel(
      dinheiroAtual: map['dinheiroAtual'] as double,
      dinheiroRecebido: map['dinheiroRecebido'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DinheiroModel.fromJson(String source) =>
      DinheiroModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DinheiroModel(dinheiroAtual: $dinheiroAtual, dinheiroRecebido: $dinheiroRecebido)';
}
