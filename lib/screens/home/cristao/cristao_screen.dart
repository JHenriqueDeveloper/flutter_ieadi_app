import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class CristaoScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int page = 20;

  @override 
  Widget build(BuildContext context) {

    void _handlerForm(String form) => context
    .read<CustomRouter>()
    .setPage(page, form: form);
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
              badge: false,
              onTap: () => _handlerForm('Dizimista'),
            ),
            ListItemMenu(
              title: 'Congregação',
              text: user.congregacao != ''
                  ? auth.congreg != null
                      ? auth?.congreg?.nome //user?.congregacao
                      : 'Não encontrada'
                  : 'Não informado',
              badge: user.congregacao == '' ? true : false,
              onTap: () => _handlerForm('Congregacao'),
            ),
            ListItemMenu(
              title: 'Afiliação',
              text: user.tipoMembro != '' ? user.tipoMembro : 'Não informado',
              badge: user.tipoMembro == '' ? true : false,
              onTap: () => _handlerForm('Afiliacao'),
            ),
            ListItemMenu(
              title: 'Situação',
              text: user.situacaoMembro != ''
                  ? user.situacaoMembro
                  : 'Não informado',
              badge: user.situacaoMembro == '' ? true : false,
              onTap: () => _handlerForm('Situacao'),
            ),
            ListItemMenu(
              title: 'Procedência',
              text: user.procedenciaMembro != ''
                  ? user.procedenciaMembro
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Procedencia'),
            ),
            ListItemMenu(
              title: 'Origem',
              text:
                  user.origemMembro != '' ? user.origemMembro : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Origem'),
            ),
            ListItemMenu(
              title: 'Data de Mudança',
              text: user.dataMudanca != '' ? user.dataMudanca : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Mudanca'),
            ),
            ListItemMenu(
              title: 'Local de Conversão',
              text: user.localConversao != ''
                  ? user.localConversao
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Local_Conversao'),
            ),
            ListItemMenu(
              title: 'Data de Conversão',
              text: user.dataConversao != ''
                  ? user.dataConversao
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Data_Conversao'),
            ),
            ListItemMenu(
              title: 'Local de Batismo \nem Águas',
              text: user.localBatismoAguas != ''
                  ? user.localBatismoAguas
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Local_Aguas'),
            ),
            ListItemMenu(
              title: 'Data de Batismo \nem Águas',
              text: user.dataBatismoAguas != ''
                  ? user.dataBatismoAguas
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Data_Aguas'),
            ),
            ListItemMenu(
              title: 'Local de Batismo no \nEspirito Santo',
              text: user.localBatismoEspiritoSanto != ''
                  ? user.localBatismoEspiritoSanto
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Local_Espirito'),
            ),
            ListItemMenu(
              title: 'Data de Batismo no \nEspirito Santo',
              text: user.dataBatismoEspiritoSanto != ''
                  ? user.dataBatismoEspiritoSanto
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Data_Espirito'),
            ),
            user.bio != ''
                ? ListItemMenu(
                    title: 'Observações',
                    text: user.bio != '' ? user.bio : 'Não informado',
                    badge: false,
                    onTap: () => _handlerForm('Bio_Cristao'),
                  )
                : Container(),
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
