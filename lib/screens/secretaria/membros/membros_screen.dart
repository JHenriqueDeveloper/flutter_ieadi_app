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

export 'forms/membros_form_screen.dart';

class MembrosScreen extends StatelessWidget {
 final PageController pageController = PageController();
  final int page = 26;

  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        void _handlerForm({String form, UserModel membro}) {
          state.membro = membro;
          return context.read<CustomRouter>().setPage(page, form: form, back: 0);
        }

        List<Widget> _listmembros() {
          List<Widget> list = [];
          for (var e in state.getListMembros) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  _handlerForm(form: e.username, membro: e);
                },
                title: Text(
                  e.username,
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
                    e.congregacao != null
                      ? e.congregacao != ''
                        ? Text(
                            'Congregação: ${context.read<CongregRepository>().getCongreg(e.congregacao).nome}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox()
                      : SizedBox(),
                    e?.isDizimista == true
                    ? Text(
                            'Dizimista',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                    : SizedBox(),
                    e?.tipoMembro != null 
                    ? e?.tipoMembro != ''
                      ? Text(
                            e.tipoMembro,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox()
                      : SizedBox(),
                    e.situacaoMembro != null 
                    ? e.situacaoMembro != ''
                      ? Text(
                            e.situacaoMembro,
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
                    e?.isVerified == false 
                      ? Text(
                        'Não verificado', 
                        style: Theme.of(context).textTheme.overline,
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
          title: 'Membros',
          backToPage: 8,
          /*
          TODO: CADASTRO DE MEMBROS PAUSADO POR ENQUANTO
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
          */
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 48),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: _listmembros(),
              ),
            )
          ],
        );
      },
    );
  }
}
