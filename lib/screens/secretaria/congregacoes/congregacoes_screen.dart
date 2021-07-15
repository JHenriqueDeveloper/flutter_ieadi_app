import 'package:cached_network_image/cached_network_image.dart';
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

class CongregacoesScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int page = 25;
  @override
  Widget build(BuildContext context) {
    return Consumer<CongregRepository>(
      builder: (_, state, __) {
        void _handlerForm({String form, CongregModel congreg}) {
          state.congreg = congreg;
          return context.read<CustomRouter>().setPage(page, form: form);
        }

        List<Widget> _listCongregs() {
          List<Widget> list = [];
          for (var e in state.getListCongregs) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  _handlerForm(form: e.nome, congreg: e);
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
                    e.idArea != null
                      ? e.idArea != ''
                        ? Text(
                            'Área: ${context.read<AreasRepository>().getArea(e.idArea).nome}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox()
                      : SizedBox(),
                    e?.unidadeConsumidora != ''
                    ? Text(
                            'U.C: ${e.unidadeConsumidora}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
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
                  FeatherIcons.chevronRight,
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
                children: _listCongregs(),
              ),
            )
          ],
        );
      },
    );
  }
}
