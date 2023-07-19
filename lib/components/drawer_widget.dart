import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:planejando_seu_dinheiro/components/drawer_zoom.dart';
import 'package:rive/rive.dart';

SafeArea drawer(context) {
  return SafeArea(
    child: Column(
      children: [
        const DrawerHeader(
          child: RiveAnimation.asset('assets/rive/newcoin.riv'),
        ),
        ListTile(
          leading: const Icon(Icons.home_rounded),
          title: const Text('Home'),
          onTap: () {
            Get.offAll(
              DrawerZoom(),
              transition: Transition.topLevel,
              duration: const Duration(seconds: 2),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.calculate),
          title: const Text('Calculadora +'),
          onTap: () {
            Get.offAll(
              DrawerZoom(
                isCalculadora: true,
              ),
              transition: Transition.topLevel,
              duration: const Duration(seconds: 2),
            );
          },
        )
      ],
    ),
  );
}
