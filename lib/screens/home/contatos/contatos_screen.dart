import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class ContatosScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int page = 19;

  @override 
  Widget build(BuildContext context) {

    void _handlerForm(String form) => context
    .read<CustomRouter>()
    .setPage(page, form: form);


    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        return DefaultScreen(
          title: 'Contatos',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(),
            ListItemMenu(
              title: 'Telefone Fixo',
              text: user.numeroFixo != '' ? user.numeroFixo : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Fixo'),
            ),
            ListItemMenu(
              title: 'Telefone Celular',
              text: user.numeroCelular != ''
                  ? user.numeroCelular
                  : 'Não informado',
              badge: user.numeroCelular == '' ? true : false,
              onTap: () => _handlerForm('Celular'),
            ),
          ],
        );
      },
    );
  }
}
