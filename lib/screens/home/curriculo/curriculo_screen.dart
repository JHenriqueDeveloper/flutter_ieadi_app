import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/screens/home/curriculo/forms/curriculo_form_screen.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class CurriculoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    void _handlerForm(String form) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CurriculoFormScreen(form)),
      );

    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        return DefaultScreen(
          title: 'Currículo',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(
              text:
                  'Mantenha seu currículo profissional atualizado, pois assim você não perderá nem uma oportunidade!',
            ),
            ListItemMenu(
              title: 'Procurando novas \noportunidades?',
              text: user.isProcurandoOportunidades ? 'Sim' : 'Não',
              badge: false,
              onTap: () => _handlerForm('Oportunidades'),
            ),
            ListItemMenu(
              title: 'Profissão',
              text: user.profissao != ''
              ? user.profissao
              : 'Não informado',
              badge: user.isProcurandoOportunidades 
              ? user.profissao == '' ? true : false:
              false,
              onTap: () => _handlerForm('Profissao'),
            ),
            ListItemMenu(
              title: 'Pretensão Salárial',
              text: user.pretensaoSalarial != ''
              ? user.pretensaoSalarial
              : 'Não informado',
              badge: user.isProcurandoOportunidades 
              ? user.pretensaoSalarial == '' ? true : false:
              false,
              onTap: () => _handlerForm('Salario'),
            ),
            ListItemMenu(
              title: 'Objetivos de Carreira',
              text: user.objetivos != ''
              ? user.objetivos
              : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Objetivos'),
            ),
            ListItemMenu(
              title: 'Biografia Profissional',
              text: user.bioProfissional != ''
              ? user.bioProfissional
              : 'Não informado',
              badge: false,
              onTap: () => _handlerForm('Bio_Profissional'),
            ),
          ],
        );
      },
    );
  }
}
