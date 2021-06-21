import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => CustomRouter(pageController),
      child: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          NavScreen(), //0
          ServicosScreen(), //1
          PessoaisScreen(), //2
          EnderecoScreen(), //3
          ContatosScreen(), //4
          CristaoScreen(), //5
          CurriculoScreen(), //6
          ContaScreen(), //7
          //secretaria
          DashboardScreen(), //8
        ],
      ),
    );
  }
}
