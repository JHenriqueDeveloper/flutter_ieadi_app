import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../helpers/util.dart';
import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../../style/style.dart';
import '../../../widgets/widgets.dart';

export 'forms/membros_form_screen.dart';

class MembrosScreen extends StatefulWidget {
  MembrosScreen();
  _MembrosScreenState createState() => _MembrosScreenState();
}

class _MembrosScreenState extends State<MembrosScreen> {
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  final int page = 26;

  UserModel membro = new UserModel();
  List<UserModel> listaMembros = [];

  String searchString = '';

  Icon searchIcon = new Icon(
    FeatherIcons.search,
    color: Colors.white,
    size: 24,
  );

  Widget titleSearch = Text(
    'Membros',
    style: TextStyle(
      color: LightStyle.paleta['Branco'],
      fontSize: 14.sp, //20.0,
      fontWeight: FontWeight.w600,
    ),
  );

  TextStyle titleStyle = GoogleFonts.roboto(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: LightStyle.paleta['Cinza'],
  );

  TextStyle textStyle = TextStyle(
    color: LightStyle.paleta['Branco'],
    height: 1,
    fontSize: 10.sp, //16,
    letterSpacing: 0,
  );

  @override
  void initState() {
    super.initState();
    titleSearch = Text(
      'Membros',
      style: TextStyle(
        color: LightStyle.paleta['Branco'],
        fontSize: 14.sp, //20.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  search() async {
    List<UserModel> lista = await MembroRepository().searchTags(searchString);
    setState(() => listaMembros = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        handlerForm({String form, UserModel membro}) {
          state.membro = membro;
          context.read<CustomRouter>().setPage(page, form: form, back: 0);
        }

        Widget searchButton() {
          if (listaMembros.length == 0) {
            this.listaMembros = state.getListMembros;
          }
          return IconButton(
            icon: this.searchIcon,
            onPressed: () {
              setState(() {
                if (this.searchIcon.icon == FeatherIcons.search) {
                  this.searchIcon =
                      new Icon(FeatherIcons.x, color: Colors.white, size: 24);
                  this.titleSearch = Container(
                    height: 48,
                    child: new TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                        search();
                      },
                      style: textStyle,
                      decoration: InputDecoration(
                          hintText: 'Buscar...',
                          filled: true,
                          fillColor: LightStyle.paleta['BgSecundario'],
                          labelStyle: GoogleFonts.roboto(
                            fontSize: 12.sp, //16,
                            color: LightStyle.paleta['Cinza'],
                            letterSpacing: 0,
                            height: 1,
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyText1,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                    ),
                  );
                } else {
                  this.searchIcon = new Icon(FeatherIcons.search,
                      color: Colors.white, size: 24);
                  this.titleSearch = Text(
                    'Membros',
                    style: Theme.of(context).textTheme.subtitle1,
                  );
                  this.searchController.text = '';
                  this.listaMembros = state.getListMembros;
                }
              });
            },
          );
        }

        Widget listagem() {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: this.listaMembros.length,
              itemBuilder: (context, index) {
                UserModel e = this.listaMembros[index];
                return ListTile(
                  key: Key(e.id),
                  onTap: () =>
                      handlerForm(form: e.username, membro: e),
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
                );
              });
        }

        return DefaultScreen(
          titleSearch: titleSearch,
          backToPage: 8,
          actions: [searchButton()],
          listView: listagem(),
        );
      },
    );
  }
}
