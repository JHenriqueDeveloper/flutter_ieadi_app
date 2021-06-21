import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class CristaoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        return DefaultScreen(
          title: 'Perfil Cristão',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(
              text: user.isVerified
                  ? 'Seus dados foram, verificados, caso precise efetuar alguma alteração solicite á secretaria.'
                  : 'Preencha os dados abaixo e solicite a verificação da sua conta, para receber o cartão de membro.',
            ),
            ListItemMenu(
              title: 'Dizimista',
              text: user.isDizimista ? 'Sim' : 'Não informado',
              badge: user.isDizimista,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Congragação',
              text: user.congregacao ?? '',
              badge: user.congregacao == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Afiliação',
              text: user.tipoMembro ?? 'Não informado',
              badge: user.tipoMembro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Situação',
              text: user.situacaoMembro ?? 'Não informado',
              badge: user.situacaoMembro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Procedência',
              text: user.procedenciaMembro ?? 'Não informado',
              badge: user.procedenciaMembro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Origem',
              text: user.origemMembro ?? 'Não informado',
              badge: user.origemMembro == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Data de Mudança',
              text: user.dataMudanca ?? 'Não informado',
              badge: user.dataMudanca == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Local de Conversão',
              text: user.localConversao ?? 'Não informado',
              badge: user.localConversao == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Data de Conversão',
              text: user.dataConversao ?? 'Não informado',
              badge: user.dataConversao == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Local de Batismo \nem Águas',
              text: user.localBatismoAguas ?? 'Não informado',
              badge: user.localBatismoAguas == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Data de Batismo \nem Águas',
              text: user.dataBatismoAguas ?? 'Não informado',
              badge: user.dataBatismoAguas == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Local de Batismo no \nEspirito Santo',
              text: user.localBatismoEspiritoSanto ?? 'Não informado',
              badge: user.localBatismoEspiritoSanto == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Data de Batismo no \nEspirito Santo',
              text: user.dataBatismoEspiritoSanto ?? 'Não informado',
              badge: user.dataBatismoEspiritoSanto == '' ? true : false,
              onTap: () => {},
            ),
            user.isVerified
            ? Container(
              color: Colors.grey[400],
              height: 40,
            )
            : Container(),
            user.isVerified
            ? Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: TextButton(
                child: Text(
                  'Solicitar alteração de dados',
                  style: Theme.of(context).textTheme.overline,
                ),
                onPressed: () => {},
              ),
            )
            : Container(),
          ],
        );
      },
    );
  }
}
