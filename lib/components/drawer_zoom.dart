import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:planejando_seu_dinheiro/modules/calculadora_page.dart';

import '../modules/home_page.dart';
import 'drawer_widget.dart';

class DrawerZoom extends StatefulWidget {
  DrawerZoom({Key? key, this.isCalculadora = false}) : super(key: key);
  bool isCalculadora;

  @override
  State<DrawerZoom> createState() => _DrawerZoomState();
}

class _DrawerZoomState extends State<DrawerZoom> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      angle: 0,
      shadowLayer1Color: Colors.amber[100],
      shadowLayer2Color: Colors.amber[300],
      androidCloseOnBackTap: true,
      mainScreenTapClose: true,
      openCurve: Curves.easeInCubic,
      closeCurve: Curves.easeOutCubic,
      menuScreenWidth: MediaQuery.of(context).size.width * .8,
      slideWidth: MediaQuery.of(context).size.width * .8,
      showShadow: true,
      menuBackgroundColor: Colors.grey[50]!,
      moveMenuScreen: false,
      menuScreen: drawer(context),
      mainScreen: widget.isCalculadora ? const CalculadoraPage() : const HomePage(),
    );
  }
}
