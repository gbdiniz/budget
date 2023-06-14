import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

PreferredSizeWidget customAppBar(String title, context) {
  return AppBar(
    toolbarHeight: 70,
    centerTitle: true,
    backgroundColor: Colors.amber,
    title: Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    leading: IconButton(
      icon: const Icon(Icons.menu),
      color: Colors.white,
      onPressed: () => ZoomDrawer.of(context)!.toggle(),
    ),
  );
}
