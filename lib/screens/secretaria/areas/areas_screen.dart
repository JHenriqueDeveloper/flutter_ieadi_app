import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../helpers/util.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../style/style.dart';
import '../../../widgets/widgets.dart';

export 'forms/areas_form_screen.dart';

class AreasScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int page = 24;

  @override
  Widget build(BuildContext context) {
    return Consumer<AreasRepository>(
      builder: (_, state, __) {
        void _handlerForm({String form, AreasModel area}) {
          state.area = area;
          return context.read<CustomRouter>().setPage(page, form: form);
        }

        List<Widget> _listAreas() {
          List<Widget> list = [];
          for (var e in state.getListAreas) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  _handlerForm(form: e.nome, area: e);
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
                    e.sede != null
                        ? e.sede != ''
                            ? Text(
                                'Sede: ${context.read<CongregRepository>().getCongreg(e.sede).nome}',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox()
                        : SizedBox(),
                    e.setor != null
                        ? e.setor != ''
                            ? Text(
                                'Setor: ${context.read<SetorRepository>().getSetor(e.setor).nome}',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox()
                        : SizedBox(),
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
                  FeatherIcons.chevronRight,
                  color: Colors.grey[400],
                ),
              ),
            );
          }
          return list;
        }

        return DefaultScreen(
          title: 'Áreas',
          backToPage: 8,
          fab: ElevatedButton(
            onPressed: () {
              _handlerForm();
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
                children: _listAreas(),
              ),
            )
          ],
        );
      },
    );
  }
}
