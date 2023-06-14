import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planejando_seu_dinheiro/components/drawer_zoom.dart';
import 'package:rive/rive.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2000),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 4000), () {
      Get.off(DrawerZoom(), transition: Transition.downToUp);
    });
    //print('Print 2');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * .3,
          child: FadeTransition(
            opacity: _animation,
            child: const RiveAnimation.asset('assets/rive/newcoin.riv'),
          ),
        ),
      ),
      bottomNavigationBar: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('V1.0'),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
