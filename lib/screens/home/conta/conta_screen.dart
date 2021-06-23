import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class ContaScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        return DefaultScreen(
          title: 'Conta',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          /*
          this.email,
    this.password,
          */
          children: [
            ListHeadMenu(
              text: 'Configurações básicas da conta de usuário.',
            ),
            ListItemMenu(
              title: 'E-mail',
              text: user.email ?? '',
              badge: false,
              onTap: () => {},
            ),
            ListItemMenu(
              title: 'Senha',
              text: '********',
              badge: false,
              onTap: () => {},
            ),

            
            /*
            Container(
              color: Colors.grey[400],
              height: 40,
            ),
            
           Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: TextButton(
                child: Text(
                  'Desativar minha conta',
                  style: Theme.of(context).textTheme.overline,
                ),
                onPressed: () => {},
              ),
            ),

            Container(
              color: Colors.grey[400],
              height: 40,
            ),
           Container(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: TextButton(
                child: Text(
                  'Remover permanentemente',
                  style: Theme.of(context).textTheme.overline,
                ),
                onPressed: () => {},
              ),
            ),
            */
          ],
        );
      },
    );
  }
}
