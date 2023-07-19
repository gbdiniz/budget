import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planejando_seu_dinheiro/modules/home_page.dart';
import 'package:rive/rive.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 5000), () {
      Get.off(const HomePage(), transition: Transition.noTransition);
    });
    //print('Print 2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: const RiveAnimation.asset('assets/rive/budget_animation.riv'),
        ),
      ),
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'V1.0',
            style: TextStyle(fontFamily: 'Raleway'),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
