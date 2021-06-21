import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class EnderecoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        return DefaultScreen(
          title: 'Endereço',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(),
            ListItemMenu(
              title: 'CEP',
              text: user.cep ?? '',
              badge: user.cep == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Estado',
              text: user.uf ?? 'Não informado',
              badge: user.uf == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Cidade',
              text: user.cidade ?? 'Não informado',
              badge: user.cidade == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Bairro',
              text: user.bairro ?? 'Não informado',
              badge: user.bairro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Logradouro',
              text: user.logradouro ?? 'Não informado',
              badge: user.logradouro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Complemento',
              text: user.complemento ?? 'Não informado',
              badge: user.complemento == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Número',
              text: user.numero ?? 'Não informado',
              badge: user.numero == '' ? true : false,
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }
}
