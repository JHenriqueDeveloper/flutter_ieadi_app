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

export 'forms/congreg_form_screen.dart';

class CongregacoesScreen extends StatefulWidget {
  CongregacoesScreen();
  _CongregacoesScreenState createState() => _CongregacoesScreenState();
}

class _CongregacoesScreenState extends State<CongregacoesScreen> {
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  final int page = 25;

  CongregModel congreg = new CongregModel();
  List<CongregModel> listaCongreg = [];

  String searchString = '';

  Icon searchIcon = new Icon(
    FeatherIcons.search,
    color: Colors.white,
    size: 24,
  );

  Widget titleSearch = Text(
    'Congregações',
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
      'Congregações',
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
    List<CongregModel> lista =
        await CongregRepository().searchTags(searchString);
    setState(() => listaCongreg = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CongregRepository>(
      builder: (_, state, __) {
        void _handlerForm({String form, CongregModel congreg}) {
          state.congreg = congreg;
          return context.read<CustomRouter>().setPage(page, form: form);
        }

        Widget searchButton() {
          if (listaCongreg.length == 0) {
            this.listaCongreg = state.getListCongregs;
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
                    'Congregações',
                    style: Theme.of(context).textTheme.subtitle1,
                  );
                  this.searchController.text = '';
                  this.listaCongreg = state.getListCongregs;
                }
              });
            },
          );
        }

        Widget listagem() {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: this.listaCongreg.length,
              itemBuilder: (context, index) {
                CongregModel e = this.listaCongreg[index];
                return ListTile(
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
              );
              });
        }

        return DefaultScreen(
          titleSearch: titleSearch,
          backToPage: 8,
          actions: [searchButton()],
          listView: listagem(),
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
        );
      },
    );
  }
}
