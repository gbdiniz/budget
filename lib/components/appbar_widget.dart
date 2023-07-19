import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(String title, context) {
  return AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
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
  );
}
