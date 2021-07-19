import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

export 'forms/endereco_form_screen.dart';

class EnderecoScreen extends StatelessWidget {
  final int page = 22; //vai para enderecoFormScreen

  @override 
  Widget build(BuildContext context) {
    void _handlerForm(String form) =>
        context.read<CustomRouter>().setPage(page, form: form);

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
              text: user.cep != '' ? user.cep : 'Não informado',
              badge: user.cep == '' ? true : false,
              onTap: () => _handlerForm('CEP'),
            ),
            ListItemMenu(
              title: 'Estado',
              text: user.uf != '' ? user.uf : 'Não informado',
              badge: user.uf == '' ? true : false,
              onTap: () =>  _handlerForm('UF'),
            ),
            ListItemMenu(
              title: 'Cidade',
              text: user.cidade != '' ? user.cidade : 'Não informado',
              badge: user.cidade == '' ? true : false,
              onTap: () =>  _handlerForm('Cidade'),
            ),
            ListItemMenu(
              title: 'Bairro',
              text: user.bairro != '' ? user.bairro : 'Não informado',
              badge: user.bairro == '' ? true : false,
              onTap: () =>  _handlerForm('Bairro'),
            ),
            ListItemMenu(
              title: 'Logradouro',
              text: user.logradouro != '' ? user.logradouro : 'Não informado',
              badge: false,
              onTap: () =>  _handlerForm('Logradouro'),
            ),
            ListItemMenu(
              title: 'Complemento',
              text: user.complemento != '' ? user.complemento : 'Não informado',
              badge: false,
              onTap: () =>  _handlerForm('Complemento'),
            ),
            ListItemMenu(
              title: 'Número',
              text: user.numero != '' ? user.numero : 'Não informado',
              badge: user.numero == '' ? true : false,
              onTap: () =>  _handlerForm('Numero'),
            ),
          ],
        );
      },
    );
  }
}
