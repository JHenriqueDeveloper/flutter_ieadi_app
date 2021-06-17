import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/repositories/auth/auth_repository.dart';

import 'package:flutter_ieadi_app/screens/home/nav/widgets/nav_widgets.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:provider/provider.dart';

class NavScreen extends StatelessWidget {
  final PageController pageController = PageController();
  //Falta implementar
  static bool _showUserCard = false;

  void _handlerExit(
    BuildContext context,
    bool isLoggedIn,
    AuthRepository auth,
  ) =>
      isLoggedIn ? auth.signOut(context) : Navigator.of(context).pushNamed('/intro');

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        String userName = firstName(auth.user?.username);
        bool isLoggedIn = auth.isLoggedId;
        return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 90,
                  centerTitle: false,
                  title: Text(
                    'Olá, ${userName ?? 'visitante'}!',
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  actions: [
                    IconButton(
                        icon: Icon(FeatherIcons.creditCard),
                        onPressed: () =>
                            {} //matricula(),  //_handlerShowUserCard(),
                        ),
                    IconButton(
                      icon: Icon(FeatherIcons.bell),
                      onPressed: () => {},
                    ),
                    IconButton(
                        icon: Icon(FeatherIcons.sliders),
                        onPressed: () => {} //_handlerScreen(DashboardScreen()),
                        )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          height: _showUserCard ? 268 : 0,
                          duration: Duration(milliseconds: 200),
                          color: LightStyle.paleta['Background'],
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 32,
                            ),
                            child: Container(), //UserCard(),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          height: 40,
                          decoration: BoxDecoration(
                            color: _showUserCard
                                ? LightStyle.paleta['BgCard']
                                : LightStyle.paleta['Background'],
                          ),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _showUserCard
                                  ? LightStyle.paleta['Background']
                                  : LightStyle.paleta['BgCard'],
                              borderRadius: BorderRadius.only(
                                topLeft: _showUserCard
                                    ? Radius.circular(0)
                                    : Radius.circular(40),
                                topRight: _showUserCard
                                    ? Radius.circular(0)
                                    : Radius.circular(40),
                                bottomLeft: _showUserCard
                                    ? Radius.circular(40)
                                    : Radius.circular(0),
                                bottomRight: _showUserCard
                                    ? Radius.circular(40)
                                    : Radius.circular(0),
                              ),
                            ),
                            height: 40,
                          ),
                        ),
                        Container(
                          color: LightStyle.paleta['BgCard'],
                          height: MediaQuery.of(context).size.height * 1.5,
                          padding: EdgeInsets.symmetric(vertical: 64),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 300,
                                child: CircleAvatar(
                                  radius: 120,
                                  backgroundColor:
                                      LightStyle.paleta['Primaria'],
                                  //backgroundImage: AssetImage('user.jpeg'),
                                  /*_image != null
                                  ? Image.file(_image)
                                  : AssetImage('user.jpeg'), */
                                  child: Container(
                                    height: 300,
                                    width: 240,
                                    alignment: Alignment.bottomRight,
                                    child: MaterialButton(
                                      onPressed: () => {}, //getImage,
                                      color: LightStyle.paleta['Primaria'],
                                      child: Icon(
                                        FeatherIcons.camera,
                                        color: LightStyle.paleta['Branco'],
                                      ),
                                      padding: EdgeInsets.all(16),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ),
                              ),

                              /*
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: CircleAvatar(
                              radius: 120,
                              backgroundColor: paleta['Primaria'],
                              backgroundImage: _image != null
                                  ? Image.file(_image)
                                  : AssetImage('user.jpeg'),
                              child: Container(
                                height: 300,
                                width: 240,
                                alignment: Alignment.bottomRight,
                                child: MaterialButton(
                                  onPressed: getImage,
                                  color: paleta['Primaria'],
                                  child: Icon(
                                    FeatherIcons.camera,
                                    color: paleta['Branco'],
                                  ),
                                  padding: EdgeInsets.all(16),
                                  shape: CircleBorder(),
                                ),
                              ),
                            ),
                          ),
                          */
                              SizedBox(height: 48),
                              Text(
                                'Pastor de Área',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              Text(
                                'Área 01',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 48),
                              NavListItem(
                                title: 'Serviços',
                                icon: FeatherIcons.server,
                                page: 5,
                              ),
                              NavListItem(
                                title: 'Informações pessoais',
                                icon: FeatherIcons.user,
                                page: 6,
                              ),
                              NavListItem(
                                title: 'Endereço',
                                icon: FeatherIcons.mapPin,
                                page: 7,
                              ),
                              NavListItem(
                                title: 'Contatos',
                                icon: FeatherIcons.phone,
                                page: 8,
                              ),
                              NavListItem(
                                title: 'Perfil Cristão',
                                icon: FeatherIcons.book,
                                page: 9,
                              ),
                              NavListItem(
                                title: 'Currículo',
                                icon: FeatherIcons.fileText,
                                page: 10,
                              ),
                              NavListItem(
                                title: 'Conta',
                                icon: FeatherIcons.key,
                                page: 11,
                              ),
                              Container(
                                color: Colors.grey[400],
                                height: 40,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 46,
                                child: TextButton(
                                  child: Text(
                                    isLoggedIn ? 'Sair' : 'Fazer Login',
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                  onPressed: () => _handlerExit(
                                    context,
                                    isLoggedIn,
                                    auth,
                                  ),
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
    );
  }
}
