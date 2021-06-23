import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/screens/home/contatos/forms/contatos_form_screen.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class ContatosScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    void _handlerForm(String form) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ContatosFormScreen(form)),
      );
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
              text: user.numeroFixo != ''
              ? user.numeroFixo
              : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Fixo'),
            ),
            ListItemMenu(
              title: 'Telefone Celular',
              text: user.numeroCelular != ''
              ? user.numeroCelular
              : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Celular'),
            ),
          ],
        );
      },
    );
  }
}
