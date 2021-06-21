import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class ContatosScreen extends StatelessWidget {
  Widget build(BuildContext context) {
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
              text: user.numeroFixo ?? '',
              badge: user.numeroFixo == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Telefone Celular',
              text: user.numeroCelular ?? 'Não informado',
              badge: user.numeroCelular == '' ? true : false,
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }
}
