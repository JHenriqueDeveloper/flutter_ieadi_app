import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/models/user/user_model.dart';
import 'package:flutter_ieadi_app/screens/home/home_screens.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

export 'forms/pessoais_form_screen.dart';

class PessoaisScreen extends StatefulWidget {
  @override
  _PessoaisScreenState createState() => _PessoaisScreenState();
}

class _PessoaisScreenState extends State<PessoaisScreen> {
  /*
  DateTime _selectedDate;

  void _selectDate(BuildContext context, String label) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2050),
        fieldLabelText: label,
        fieldHintText: 'dd/MM/yyyy',
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        });
    if (picked != null && picked != _selectedDate)
      _selectedDate = picked;
  }
  */

  final snackBar = SnackBar(
    content: Text('Solicitação Recebida!'),
    backgroundColor: LightStyle.paleta['Primaria'],
  );

  void _handlerForm(String form) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => PessoaisFormScreen(form)),
  );

  //context.read<CustomRouter>().setPage(form);

  Widget build(BuildContext context) {
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
                    'Seus dados cívis são importantes, para confirmar sua identidade e registrar sua afiliação neste Ministério. \nNunca serão utilizados para outros fins.'),
            ListItemMenu(
              title: 'Nome',
              text: user.username ?? '',
              badge: user.username == '' ? true : false,
              onTap: () => _handlerForm('Nome'),
            ),
            ListItemMenu(
              title: 'Gênero',
              text: user.genero ?? 'Não informado',
              badge: user.genero == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'CPF',
              text: user.cpf ?? 'Não informado',
              badge: user.cpf == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'RG',
              text: user.rg ?? 'Não informado',
              badge: user.rg == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Naturalidade',
              text: user.naturalidade ?? 'Não informado',
              badge: user.naturalidade == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Nome do Pai',
              text: user.nomePai ?? 'Não informado',
              badge: user.nomePai == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Nome da Mãe',
              text: user.nomeMae ?? 'Não informado',
              badge: user.nomeMae == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Estado Civil',
              text: user.estadoCivil ?? 'Não informado',
              badge: user.estadoCivil == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Tipo Sanguineo',
              text: user.tipoSanguineo ?? 'Não informado',
              badge: user.tipoSanguineo == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Título de Eleitor',
              text: user.tituloEleitor ?? 'Não informado',
              badge: user.tituloEleitor == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Zona Eleitoral',
              text: user.zonaEleitor ?? 'Não informado',
              badge: user.zonaEleitor == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Seção Eleitoral',
              text: user.secaoEleitor ?? 'Não informado',
              badge: user.secaoEleitor == '' ? true : false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Especial',
              text: user.isPortadorNecessidade ? 'Sim' : 'Não',
              badge: false,
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }
}

/*

class _PessoaisScreenState extends State<PessoaisScreen> {
  final snackBar = SnackBar(
    content: Text('Solicitação Recebida!'),
    backgroundColor: paleta['Primaria'],
  );

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  _selectDate(BuildContext context, String label) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      fieldLabelText: label,
      fieldHintText: 'dd/MM/yyyy',

      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      }

    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }
  */
