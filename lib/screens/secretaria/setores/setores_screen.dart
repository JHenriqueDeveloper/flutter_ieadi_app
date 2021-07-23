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

export 'forms/setor_form_screen.dart';

class SetorScreen extends StatefulWidget {
  SetorScreen();
  _SetorScreenState createState() => _SetorScreenState();
}

class _SetorScreenState extends State<SetorScreen> {
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  final int page = 29;

  SetorModel setor = new SetorModel();
  List<SetorModel> listaSetores = [];

  String searchString = '';

  Icon searchIcon = new Icon(
    FeatherIcons.search,
    color: Colors.white,
    size: 24,
  );

  Widget titleSearch = Text(
    'Setores',
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
      'Setores',
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
    List<SetorModel> lista = await SetorRepository().searchTags(searchString);
    setState(() => listaSetores = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SetorRepository>(
      builder: (_, state, __) {
        void _handlerForm({String form, SetorModel setor}) {
          state.setor = setor;
          return context.read<CustomRouter>().setPage(page, form: form);
        }

        Widget searchButton() {
          if (listaSetores.length == 0) {
            this.listaSetores = state.getListSetor;
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
                    'Áreas',
                    style: Theme.of(context).textTheme.subtitle1,
                  );
                  this.searchController.text = '';
                  this.listaSetores = state.getListSetor;
                }
              });
            },
          );
        }

        Widget listagem() {
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: this.listaSetores.length,
              itemBuilder: (context, index) {
                SetorModel e = this.listaSetores[index];
                return ListTile(
                  key: Key(e.id),
                  onTap: () {
                    _handlerForm(form: e.nome, setor: e);
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
                              ? Consumer<CongregRepository>(
                                  builder: (_, congreg, __) {
                                    return Text(
                                      'Sede: ${congreg.getCongreg(e.sede).nome}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    );
                                  },
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
