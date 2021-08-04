import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
//import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MinisterioOptionsScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int pageBack = 14;
  final int pageForm = 27;

  @override
  Widget build(BuildContext context) {
    String _title = context.read<CustomRouter>().getScreen;
    String _form = context.read<CustomRouter>().getForm;

    TextStyle style = GoogleFonts.roboto(
      fontSize: 16,
      height: 1.5,
      letterSpacing: 0,
      fontWeight: FontWeight.bold,
      color: LightStyle.paleta['Cinza'],
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<MinisterioRepository>(
        builder: (_, state, __) {
          void _handlerForm({
            String form,
            String screen,
            int page,
          }) {
            return context
                .read<CustomRouter>()
                .setPage(page, form: form, screen: screen);
          }

          Widget item(e, Function onTap) {
            return ListTile(
              onTap: onTap,
              title: Text(
                e.username,
                style: style,
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
              trailing: !state.isLoading 
              ? Icon(
                  FeatherIcons.x,
                  color: Colors.grey[400],
                )
              : SizedBox(),
            );
          }

          List<Widget> _listagem(List list, {String option}) {
            List<Widget> itens = [];
            if (list.length > 0) {
              list = list.reversed.toList();
              for (var e in list) {
                itens.add(item(e, () {
                  if (!state.isLoading) {
                    state.updateLista(
                      e.id,
                      option,
                      onSuccess: () {},
                      onFail: () {},
                    );
                  }

                  _listagem(list);
                }));
              }
            }
            return itens;
          }

          Map<String, List<Widget>> option = {
            'Conselho Fiscal': _listagem(
              state.listFiscal ?? [],
              option: 'fiscal',
            ),
            'Conselho de Ética': _listagem(
              state.listEtica ?? [],
              option: 'etica',
            ),
            'Departamentos': _listagem(
              state.ministerio?.departamentos ?? [],
              option: 'departamentos',
            ),
            'Pastores': _listagem(
              state.listPastores ?? [],
              option: 'pastores',
            ),
            'Evangelistas Consagrados': _listagem(
              state.listEvanConsagrados ?? [],
              option: 'consagrados',
            ),
            'Evangelistas Autorizados': _listagem(
              state.listEvanAutorizados ?? [],
              option: 'autorizados',
            ),
            'Evangelistas Locais': _listagem(
              state.listEvanLocais ?? [],
              option: 'locais',
            ),
            'Presbíteros': _listagem(
              state.listPresbiteros ?? [],
              option: 'presbiteros',
            ),
            'Diáconos': _listagem(
              state.listDiaconos ?? [],
              option: 'diaconos',
            ),
            'Auxiliares': _listagem(
              state.listAuxiliares ?? [],
              option: 'auxiliares',
            ),
            'Obreiros': _listagem(
              state.listObreiros ?? [],
              option: 'obreiros',
            ),
          };

          return DefaultScreen(
            title: _title,
            backToPage: 14,
            fab: ElevatedButton(
              onPressed: () => _handlerForm(
                form: _form,
                page: pageForm,
              ),
              child: const Icon(FeatherIcons.plus),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
            ),
            children: option[_title],
          );
        },
      ),
    );
  }
}
