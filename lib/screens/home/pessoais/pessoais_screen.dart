import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

export 'forms/pessoais_form_screen.dart';

class PessoaisScreen extends StatefulWidget {
  @override
  _PessoaisScreenState createState() => _PessoaisScreenState();
}

class _PessoaisScreenState extends State<PessoaisScreen> {
  final PageController pageController = PageController();
  final int page = 23;

  @override
  Widget build(BuildContext context) {
    void _handlerForm(String form) =>
        context.read<CustomRouter>().setPage(page, form: form);

    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;

        return DefaultScreen(
          title: 'Informações pessoais',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(
              text:
                  'Seus dados cívis são importantes, para confirmar sua identidade e registrar sua afiliação neste Ministério. \nNunca serão utilizados para outros fins.',
            ),
            ListItemMenu(
              title: 'Nome',
              text: user.username ?? '',
              badge: user.username == '' ? true : false,
              onTap: () => _handlerForm('Nome'),
            ),
            ListItemMenu(
              title: 'Gênero',
              text: user.genero != '' ? user.genero : 'Não informado',
              badge: user.genero == '' ? true : false,
              onTap: () => _handlerForm('Genero'),
            ),
            ListItemMenu(
              title: 'CPF',
              text: user.cpf == '' ? 'Não informado' : user.cpf,
              badge: user.cpf == '' ? true : false,
              onTap: () => _handlerForm('CPF'),
            ),
            ListItemMenu(
              title: 'RG',
              text: user.rg != '' ? user.rg : 'Não informado',
              badge: user.rg == '' ? true : false,
              onTap: () => _handlerForm('RG'),
            ),
            ListItemMenu(
              title: 'Naturalidade',
              text:
                  user.naturalidade != '' ? user.naturalidade : 'Não informado',
              badge: user.naturalidade == '' ? true : false,
              onTap: () => _handlerForm('Naturalidade'),
            ),
            ListItemMenu(
              title: 'Data \nde Nascimento',
              text: user.dataNascimento != ''
                  ? user.dataNascimento
                  : 'Não informado',
              badge: user.dataNascimento == '' ? true : false,
              onTap: () => _handlerForm('Nascimento'),
            ),
            ListItemMenu(
              title: 'Nome do Pai',
              text: user.nomePai != '' ? user.nomePai : 'Não informado',
              badge: user.nomePai == '' ? true : false,
              onTap: () => _handlerForm('Pai'),
            ),
            ListItemMenu(
              title: 'Nome da Mãe',
              text: user.nomeMae != '' ? user.nomeMae : 'Não informado',
              badge: user.nomeMae == '' ? true : false,
              onTap: () => _handlerForm('Mae'),
            ),
            ListItemMenu(
              title: 'Estado Civil',
              text: user.estadoCivil != '' ? user.estadoCivil : 'Não informado',
              badge: user.estadoCivil == '' ? true : false,
              onTap: () => _handlerForm('Civil'),
            ),
            ListItemMenu(
              title: 'Tipo Sanguineo',
              text: user.tipoSanguineo != ''
                  ? user.tipoSanguineo
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Sangue'),
            ),
            ListItemMenu(
              title: 'Título de Eleitor',
              text: user.tituloEleitor != ''
                  ? user.tituloEleitor
                  : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Titulo'),
            ),
            ListItemMenu(
              title: 'Zona Eleitoral',
              text: user.zonaEleitor != '' ? user.zonaEleitor : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Zona'),
            ),
            ListItemMenu(
              title: 'Seção Eleitoral',
              text:
                  user.secaoEleitor != '' ? user.secaoEleitor : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Secao'),
            ),
            ListItemMenu(
              title: 'Especial',
              text: user.isPortadorNecessidade ? 'Sim' : 'Não',
              badge: false,
              onTap: () => _handlerForm('Especial'),
            ),
            user.isPortadorNecessidade
                ? ListItemMenu(
                    title: 'Tipo de \nNecessidade \nEspecial',
                    text: user.tipoNecessidade != ''
                        ? user.tipoNecessidade
                        : 'Não Informado',
                    badge: user.tipoNecessidade != '' ? false : true,
                    onTap: () => _handlerForm('Tipo Necessidade'),
                  )
                : Container(),
            user.isPortadorNecessidade
                ? ListItemMenu(
                    title: 'Descrição da \nNecessidade \nEspecial',
                    text: user.descricaoNecessidade != ''
                        ? user.descricaoNecessidade
                        : 'Não Informado',
                    badge: user.descricaoNecessidade != '' ? false : true,
                    onTap: () => _handlerForm('Descricao Necessidade'),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
