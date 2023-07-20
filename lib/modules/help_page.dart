import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:planejando_seu_dinheiro/components/variables.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: _introKey,
      pages: [
        PageViewModel(
          title: '',
          bodyWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    child: Image.asset(
                      'assets/icon/icon.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'O que é o Budget?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'O Budget é um app que te auxilia a organizar a sua vida financeira, registrando seus gastos e ganhos para que você consiga utilizar melhor o seu dinheiro',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          title: '',
          bodyWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Como funciona?',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: notThatBlack),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'É bem simples! Clique no botão de adicionar no canto superior direito e escolha as opções: tipo de registro, histórico, categoria e valor.',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      'assets/images/intro2.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          title: '',
          bodyWidget: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Como adicionar um registro?',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: notThatBlack,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset(
                      'assets/images/exemplo.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '1. Escolha se é entrada (adicionar dinheiro) ou saída (registar um gasto).\n',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '2. De onde você recebeu ou com o que gastou.\n',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '3. A que grupo pertence esse gasto? Exemplo: transporte, lazer, alimentação, etc\n',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.left,
                ),
                Text(
                  '4. Montante do dinheiro                                                    ',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
      showDoneButton: true,
      done: Text('Voltar'),
      onDone: () {
        Get.back();
      },
      showNextButton: false,
    );
  }
}
