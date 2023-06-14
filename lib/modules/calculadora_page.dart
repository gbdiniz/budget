import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:planejando_seu_dinheiro/components/appbar_widget.dart';
import 'package:planejando_seu_dinheiro/components/navbar_widget.dart';

import 'home_page.dart';

class CalculadoraPage extends StatefulWidget {
  const CalculadoraPage({super.key});

  @override
  State<CalculadoraPage> createState() => _CalculadoraPageState();
}

class _CalculadoraPageState extends State<CalculadoraPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar('Calculadora Financeira', context),
      body: Container(),
      bottomNavigationBar: customNavBar(1),
    );
  }
}
