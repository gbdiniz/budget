import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../modules/calculadora_page.dart';
import '../modules/home_page.dart';

Container customNavBar(int index) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withOpacity(.1),
        )
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: Colors.black,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.grey[100]!,
          color: Colors.black,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Home',
              onPressed: () {
                Get.to(
                  const HomePage(),
                  transition: Transition.noTransition,
                );
              },
            ),
            GButton(
              icon: Icons.calculate,
              text: 'Calculadora',
              onPressed: () {
                Get.to(
                  const CalculadoraPage(),
                  transition: Transition.noTransition,
                );
              },
            ),
          ],
          selectedIndex: index,
          // onTabChange: (index) {
          //   setState(() {
          //     _selectedIndex = index;
          //   });
          // },
        ),
      ),
    ),
  );
}
