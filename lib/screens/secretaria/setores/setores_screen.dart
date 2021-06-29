import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/screens/secretaria/setores/forms/setor_form_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../helpers/util.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../style/style.dart';
import '../../../widgets/widgets.dart';

class SetorScreen extends StatelessWidget {
  void _handlerForm({
    BuildContext ctx,
    SetorModel setor,
  }) =>
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => SetorForm(setor: setor)),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<SetorRepository>(
      builder: (_, state, __) {
        List<Widget> _listSetor() {
          List<Widget> list = [];
          for (var e in state.getListSetor) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  _handlerForm(ctx: context, setor: e);
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
                subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    e.createdAt != null
                        ? Text(
                            'criado em: ${formataData(data: e.createdAt)}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox(),
                    e?.isActive == false
                        ? Text(
                            'situação: Inativa',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox(),
                  ],
                ),
                leading: null,
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
          title: 'Setores',
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
                children: _listSetor(),
              ),
            )
          ],
        );
      },
    );
  }
}
