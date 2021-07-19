import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CertificadoBatismo extends StatefulWidget{
  CertificadoBatismo();
  _CertificadoBatismoState createState() => _CertificadoBatismoState();
}

class _CertificadoBatismoState extends State<CertificadoBatismo>{
  final PageController pageController = PageController();
  final int page = 12;

  UserModel membro = new UserModel();
  List<UserModel> batizados = [];

  String search = '';
  bool isFab = false;

  @override
  void initState() {
    super.initState();
  }

  void handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(page);

  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        String _title = context.read<CustomRouter>().getScreen;

        search(String data) async {
          batizados = await state.getBatismoMembros(data);
          isFab = true;
        }

        List<Widget> _listagem() {
          List<Widget> list = [];
          for (var e in batizados) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  //_handlerForm(form: e.username, membro: e);
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
              ),
            );
          }
          return list;
        }

        return DefaultScreen(
          title: _title,
          backToPage: page,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: TextField(
                keyboardType: TextInputType.datetime,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: 'Informe a data',
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  fillColor: LightStyle.paleta['PrimariaCinza'],
                  icon: Icon(
                    FeatherIcons.search,
                    color: Colors.grey[400],
                  ),
                ),
                //enabled: !state.isLoading,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                onChanged: (value) => search(value),
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: _listagem(),
            )
          ],
          fab: ElevatedButton(
            onPressed: isFab
                ? () {
                    //TODO: imprimir cartoes
                  }
                : null,
            child: const Icon(FeatherIcons.copy),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }
}
