import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/widgets.dart';

export 'ministerio_options_screen.dart';
export 'forms/ministerio_form_screen.dart';

class MinisterioScreen extends StatelessWidget{
  final PageController pageController = PageController();
  final int pageForm = 27;
  final int pageOptions = 28;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Consumer<MinisterioRepository>(
        builder: (_, state, __) {
          void _handlerForm({
            String form, 
            String screen,
            int page,
          }) {
          return context.read<CustomRouter>().setPage(page, form: form, screen: screen);
        }
          var ministerio = state.ministerio;
          String profileImageUrl =
              context.read<MinisterioRepository>().imageUrl;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: Theme.of(context).backgroundColor,
              toolbarHeight: 60.sp,
              centerTitle: false,
              title: Text(
                ministerio.sigla ?? 'Ministério',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.headline5,
              ),
              leadingWidth: 64,
              leading: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: FloatingActionButton(
                  mini: true,
                  child: Icon(FeatherIcons.chevronLeft),
                  onPressed: () => context.read<CustomRouter>().setPage(8),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(FeatherIcons.edit),
                  onPressed: () =>
                      _handlerForm(
                        form: 'Informações básicas',
                        page: pageForm,
                      ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                color: LightStyle.paleta['BgCard'],
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24.sp),
                          bottomRight: Radius.circular(24.sp),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 24.sp,
                        horizontal: 24.sp,
                      ),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: LightStyle.paleta['Primaria'],
                            backgroundImage: profileImageUrl != null
                              ? CachedNetworkImageProvider(profileImageUrl)
                              : null,
                          ),
                          SizedBox(height: 16),
                          Container(
                            child: Text(
                              ministerio.nome,
                              style: Theme.of(context).textTheme.subtitle2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 32),
                          ListTile(
                            title: Text(
                              'Igreja sede',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              state?.sede?.nome ?? 'Não informado',
                              style: state?.sede?.nome != null
                                  ? LightStyle.textOverlinePrimary
                                  : Theme.of(context).textTheme.overline,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Presidente',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              state?.presidente?.username ?? 'Não informado',
                              style: state?.presidente?.username != null
                                  ? LightStyle.textOverlinePrimary
                                  : Theme.of(context).textTheme.overline,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'CNPJ',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              ministerio.cnpj ?? 'Não informado',
                              style: ministerio.cnpj != null
                                  ? LightStyle.textOverlinePrimary
                                  : Theme.of(context).textTheme.overline,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Fundada em',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              ministerio.fundacao ?? 'Não informado',
                              style: ministerio.fundacao != null
                                  ? LightStyle.textOverlinePrimary
                                  : Theme.of(context).textTheme.overline,
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Contatos',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            trailing: Text(
                              '${ministerio?.telefoneCelular ?? 'Não informado'}\n${ministerio?.telefoneFixo ?? 'Não informado'}',
                              style: ministerio.telefoneCelular != null
                                  ? LightStyle.textOverlinePrimary
                                  : Theme.of(context).textTheme.overline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //Lista
                    Container(
                      color: LightStyle.paleta['BgCard'],
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(
                        top: 32,
                        bottom: 64,
                      ),
                      child: Column(
                        children: [
                          ListItemMenu(
                            title: 'Conselho Fiscal',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Fiscal',
                              screen: 'Conselho Fiscal',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Conselho de Ética',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Conselheiro',
                              screen: 'Conselho de Ética',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Departamentos',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Departamentos',
                              screen: 'Departamentos',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Pastores',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Pastor',
                              screen: 'Pastores',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Evangelistas Consagrados',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar \nEvangelista Consagrado',
                              screen: 'Evangelistas Consagrados',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Evangelistas Autorizados',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar \nEvangelista Autorizado',
                              screen: 'Evangelistas Autorizados',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Evangelistas Locais',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar \n Evangelista Local',
                              screen: 'Evangelistas Locais',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Presbíteros',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Presbítero',
                              screen: 'Presbíteros',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Diáconos',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Diácono',
                              screen: 'Diáconos',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Auxiliares',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Auxiliar',
                              screen: 'Auxiliares',
                              page: pageOptions,
                            ),
                          ),
                          ListItemMenu(
                            title: 'Obreiros',
                            icon: FeatherIcons.chevronRight,
                            badge: false,
                            onTap: () => _handlerForm(
                              form: 'Adicionar Obreiro',
                              screen: 'Obreiros',
                              page: pageOptions,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
