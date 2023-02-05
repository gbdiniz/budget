// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:planejando_seu_dinheiro/Database/database_sqlite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DinheiroModel> dinheiros = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _select();
  }

  _select() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    print(result);

    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      isLoading = false;
    });
  }

  _addMoney() async {
    final database = await DatabaseSqlite().openConnection();
    var result = await database.query('psd');
    setState(() {
      dinheiros = result
          .map<DinheiroModel>((result) => DinheiroModel.fromMap(result))
          .toList();
      double total = dinheiros[0].dinheiroatual + 100.50;
      database.update(
        'psd',
        {'dinheiroatual': total},
        where: 'dinheiroatual = ?',
        whereArgs: [dinheiros[0].dinheiroatual],
      );
      print(dinheiros[0].dinheiroatual);
    });
    _select();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var dinheiroFormatado = dinheiros[0]
                  .dinheiroatual
                  .toStringAsFixed(2)
                  .replaceAll('.', ',');

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    width: double.infinity,
                    height: 160,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Dinheiros',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              'R\$ $dinheiroFormatado',
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
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
                    _addMoney();
                  },
                  child: const Icon(Icons.add),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

class DinheiroModel {
  int id;
  double dinheiroatual;
  DinheiroModel({
    required this.id,
    required this.dinheiroatual,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'dinheiroatual': dinheiroatual,
    };
  }

  factory DinheiroModel.fromMap(Map<String, dynamic> map) {
    return DinheiroModel(
      id: map['id'] as int,
      dinheiroatual: map['dinheiroatual'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory DinheiroModel.fromJson(String source) =>
      DinheiroModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DinheiroModel(id: $id, dinheiroatual: $dinheiroatual)';
}
