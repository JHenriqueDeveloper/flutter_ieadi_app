import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class CurriculoScreen extends StatelessWidget {
  Widget build(BuildContext context) {
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
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Profissão',
              text: user.profissao ?? '',
              badge: false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Pretensão Salárial',
              text: user.pretensaoSalarial ?? 'Não informado',
              badge: false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Objetivos de Carreira',
              text: user.objetivos ?? 'Não informado',
              badge: false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Biografia Profissional',
              text: user.bioProfissional ?? 'Não informado',
              badge: false,
              onTap: () => {},
            ),
          ],
        );
      },
    );
  }
}
