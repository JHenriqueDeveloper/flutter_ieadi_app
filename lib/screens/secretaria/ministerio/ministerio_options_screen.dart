import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
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
              trailing: Icon(
                FeatherIcons.x,
                color: Colors.grey[400],
              ),
            );
          }

          List<Widget> _listagem(List list) {
            List<Widget> itens = [];

            if (list.length > 0) {
              list = list.reversed.toList();
              for (var e in list) {
                itens.add(item(e, () {
                  print(e.id);
                  //replytile.removeWhere((item) => item.id == '001')
                  //TODO: DESENVOLVER O REMOVE ITEM
                  list.removeWhere((item) => item.id == e.id);
                  _listagem(list);
                }));
              }
            }
            return itens;
          }

          Map<String, List<Widget>> option = {
            'Conselho Fiscal': _listagem(state.listFiscal ?? []),
            'Conselho de Ética': _listagem(state.listEtica ?? []),
            'Departamentos': _listagem(state.ministerio?.departamentos ?? []),
            'Pastores': _listagem(state.listPastores ?? []),
            'Evangelistas Consagrados':
                _listagem(state.listEvanConsagrados ?? []),
            'Evangelistas Autorizados':
                _listagem(state.listEvanAutorizados ?? []),
            'Evangelistas Locais':
                _listagem(state.listEvanLocais ?? []),
            'Presbíteros': _listagem(state.listPresbiteros ?? []),
            'Diáconos': _listagem(state.listDiaconos ?? []),
            'Auxiliares': _listagem(state.listAuxiliares ?? []),
            'Obreiros': _listagem(state.listObreiros ?? []),
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
