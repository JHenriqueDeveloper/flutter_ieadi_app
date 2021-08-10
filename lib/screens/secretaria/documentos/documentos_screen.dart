import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:provider/provider.dart';

import '../../../widgets/widgets.dart';
export 'form/documentos_forms_screen.dart';

class DocumentosScreen extends StatelessWidget {
  final PageController pageController = PageController();
  //final int page = 30;

  @override
  Widget build(BuildContext context) {
    return Consumer<SolicitacoesRepository>(
      builder: (_, state, __) {
        void _handlerForm(int page, String screen) {
          return context.read<CustomRouter>().setPage(page, screen: screen);
        }

        return DefaultScreen(
          title: 'Documentos',
          backToPage: 8,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 48),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  //SizedBox(height: 48),
                  ListItemMenu(
                    title: 'Cartão de Membro',
                    icon: FeatherIcons.creditCard,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Cartão de Membro'),
                  ),
                  ListItemMenu(
                    title: 'Credencial do Ministério',
                    icon: FeatherIcons.briefcase,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Credencial do Ministério'),
                  ),
                  ListItemMenu(
                    title: 'Certificado de Batismo',
                    icon: FeatherIcons.award,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Certificado de Batismo'),
                  ),
                  ListItemMenu(
                    title: 'Certificado de Apresentação',
                    icon: FeatherIcons.gift,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Certificado de Apresentação'),
                  ),
                  ListItemMenu(
                    title: 'Carta de Mudança',
                    icon: FeatherIcons.mapPin,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Carta de Mudança'),
                  ),
                  ListItemMenu(
                    title: 'Carta de Recomendação',
                    icon: FeatherIcons.mail,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Carta de Recomendação'),
                  ),
                  ListItemMenu(
                    title: 'Declaração de Membro',
                    icon: FeatherIcons.userCheck,
                    badge: false,
                    onTap: () => _handlerForm(31, 'Declaração de Membro'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
