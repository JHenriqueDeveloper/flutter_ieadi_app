import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:provider/provider.dart';

import '../../../widgets/widgets.dart';

export 'forms/documentos_form_screen.dart';
export 'screens/carta_mudanca/carta_mudanca_screen.dart';
export 'screens/carta_recomendacao/carta_recomendaca_screen.dart';
export 'screens/cartao_membro/cartao_membro_screen.dart';
export 'screens/certificado_apresentacao/certificado_apresentacao_screen.dart';
export 'screens/certificado_batismo/certificado_batismo_screen.dart';
export 'screens/credencial_ministerio/credencial_ministerio_screen.dart';
export 'screens/declaracao_membro/declaracao_membro_screen.dart';

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
                    onTap: () => _handlerForm(34, 'Cartão de Membro'),
                  ),
                  ListItemMenu(
                    title: 'Credencial Ministério',
                    icon: FeatherIcons.briefcase,
                    badge: false,
                    onTap: () => _handlerForm(37, 'Credencial Ministério'),
                  ),
                  ListItemMenu(
                    title: 'Certificado de Batismo',
                    icon: FeatherIcons.award,
                    badge: false,
                    onTap: () => _handlerForm(36, 'Certificado de Batismo'),
                  ),
                  ListItemMenu(
                    title: 'Certificado de Apresentação',
                    icon: FeatherIcons.gift,
                    badge: false,
                    onTap: () => _handlerForm(35, 'Certificado de Apresentação'),
                  ),
                  ListItemMenu(
                    title: 'Carta de Mudança',
                    icon: FeatherIcons.mapPin,
                    badge: false,
                    onTap: () => _handlerForm(32, 'Carta de Mudança'),
                  ),
                  ListItemMenu(
                    title: 'Carta de Recomendação',
                    icon: FeatherIcons.mail,
                    badge: false,
                    onTap: () => _handlerForm(33, 'Carta de Recomendação'),
                  ),
                  ListItemMenu(
                    title: 'Declaração de Membro',
                    icon: FeatherIcons.userCheck,
                    badge: false,
                    onTap: () => _handlerForm(38, 'Declaração de Membro'),
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
