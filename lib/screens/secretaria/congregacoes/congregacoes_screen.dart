import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/screens/secretaria/congregacoes/forms/congreg_form_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../style/style.dart';
import '../../../widgets/widgets.dart';

class CongregacoesScreen extends StatelessWidget {


  void _handlerForm({
    BuildContext ctx,
    CongregModel congreg,
  }) => Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => CongregForm(congreg: congreg)),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<CongregRepository>(
      builder: (_, state, __) {
        String _verificaSede(e) {
          if (e.isSedeCampo != null && e.isSedeCampo) return 'Sede do Campo';
          if (e.isSedeArea != null && e.isSedeArea) return 'Sede de Área';
          if (e.isSedeSetor != null && e.isSedeSetor) return 'Sede de Setor';
          return '';
        }

        List<Widget> _listCongregs() {
          List<Widget> list = [];
          for (var e in state.getListCongregs) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  _handlerForm(ctx: context, congreg: e);
                },
                title: Text(
                  e.nome,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color: LightStyle.paleta['Cinza'],
                  ),
                ),
                subtitle: _verificaSede(e) != ''
                    ? Text(
                        _verificaSede(e),
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : null,
                leading: CircleAvatar(
                  //radius: radius,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: e.profileImageUrl != null 
                  ? e.profileImageUrl != ''
                    ? CachedNetworkImageProvider(e.profileImageUrl)
                    : null
                  : null,
                  child: e.profileImageUrl != null
                  ? e.profileImageUrl != ''
                    ? null
                    : Icon(
                        FeatherIcons.home,
                        color: Theme.of(context).canvasColor,
                      )
                  : Icon(
                        FeatherIcons.home,
                        color: Theme.of(context).canvasColor,
                      ),
                ),
                trailing: Icon(
                  FeatherIcons.moreHorizontal,
                  color: Colors.grey[400],
                ),
              ),
            );
          }
          return list;
        }

        return DefaultScreen(
          title: 'Congregações',
          backToPage: 8,
          fab: ElevatedButton(
            onPressed: () {
              _handlerForm(ctx: context);
            },
            child: const Icon(FeatherIcons.plus),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
          ),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 48),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: _listCongregs(),
              ),
            )
          ],
        );
      },
    );
  }
}