import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';

class ServicosScreen extends StatelessWidget {
  final snackBar = SnackBar(
    content: Text('Solicitação Recebida!'),
    backgroundColor: LightStyle.paleta['Primaria'],
  );

  Widget build(BuildContext context) {
    void _showDialog({
      String title,
      String body,
      String button,
    }) =>
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                title,
              ),
              content: Text(
                body,
                style: GoogleFonts.roboto(
                  color: LightStyle.paleta['Cinza'],
                  letterSpacing: 0,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar',
                      style: GoogleFonts.roboto(
                        color: LightStyle.paleta['Erro'],
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      )),
                ),
                TextButton(
                  child: Text(button,
                      style: GoogleFonts.roboto(
                        color: LightStyle.paleta['Primaria'],
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      )),
                  onPressed: () => {
                    Navigator.of(context).pop(),
                    //_showSnack(msg: msg)
                    ScaffoldMessenger.of(context).showSnackBar(snackBar)
                  },
                ),
              ],
            );
          },
        );

    void _handlerScreen(String form) {
      context.read<CustomRouter>().setPage(0);

      //TODO CRIAR O FORM
    }

    //context.read<CustomRouter>().setPage(0),

    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        //var user = auth.user;
        return DefaultScreen(
          title: 'Serviços',
          backToPage: 0,
          padding: const EdgeInsets.only(
            bottom: 32,
          ),
          children: [
            ListHeadMenu(
              text:
                  'Alguns serviços podem levar demorar dias para serem analizados',
            ),
            ListItemMenu(
              badge: false,
              title: 'Cartão de membro',
              icon: FeatherIcons.creditCard,
              onTap: () => _showDialog(
                title: 'Solicitar Cartão de membro',
                body:
                    'Se não encontrarmos pendências em seu cadastro, seu cartão será confeccionado.',
                button: 'Confirmar',
              ),
            ),
            ListItemMenu(
              badge: false,
              title: 'Declaração de membro',
              icon: FeatherIcons.fileText,
              onTap: () => _showDialog(
                title: 'Solicitar Declaração de Membro',
                body:
                    'Sua solicitação será analizada pela secretária e em breve retornaremos uma mensagem a você.',
                button: 'Confirmar',
              ),
            ),
            ListItemMenu(
              badge: false,
              title: 'Certificado de batismo',
              icon: FeatherIcons.award,
              onTap: () => _showDialog(
                title: 'Solicitar Certificado de Batismo',
                body:
                    'Sua solicitação será analizada pela secretária e em breve retornaremos uma mensagem a você.',
                button: 'Confirmar',
              ),
            ),
            ListItemMenu(
              badge: false,
              title: 'Certificado de apresentação',
              icon: FeatherIcons.gift,
              onTap: () => _showDialog(
                title: 'Solicitar Certificado de Apresentação de Criança',
                body:
                    'Sua solicitação será analizada pela secretária e em breve retornaremos uma mensagem a você.',
                button: 'Confirmar',
              ),
            ),
            ListItemMenu(
              badge: false,
              title: 'Carta de recomendação',
              icon: FeatherIcons.bookmark,
              onTap: () => _handlerScreen('Carta de Recomendação'),
            ),
            ListItemMenu(
              badge: false,
              title: 'Carta de mudança',
              icon: FeatherIcons.briefcase,
              onTap: () => _handlerScreen('Carta de Mudança'),
            ),
            ListItemMenu(
              badge: false,
              title: 'Outras Solicitações',
              icon: FeatherIcons.plus,
              onTap: () => _handlerScreen('Outras Solicitações'),
            ),
          ],
        );
      },
    );
  }
}
