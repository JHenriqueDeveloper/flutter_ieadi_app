import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';

import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:provider/provider.dart';

class NavScreen extends StatefulWidget {
  NavScreen();

  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final PageController pageController = PageController();

  bool _showUserCard = false;

  void _handlerShowUserCard() => setState(() => _showUserCard = !_showUserCard);

  SnackBar snackBar({
    String text,
    String paleta,
  }) => SnackBar(
        content: Text(text),
        backgroundColor: LightStyle.paleta[paleta],
      );

  void _handlerShowVerificado(bool isVerified) => isVerified
      ? ScaffoldMessenger.of(context).showSnackBar(
        snackBar(
          text: 'Parabéns, você foi verificado!',
          paleta: 'Sucesso',
        ))
      : ScaffoldMessenger.of(context).showSnackBar(
        snackBar(
          text: 'Verifique sua conta para ter acesso completo ao aplicativo.',
          paleta: 'Erro',
        ));

  @override
  Widget build(BuildContext context) {
    void _handlerExit(
      bool isLoggedIn,
      AuthRepository auth,
    ) =>
        isLoggedIn
            ? auth.signOut(context)
            : Navigator.of(context).pushNamed('/intro');

    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        var user = auth.user;
        String userName = firstName(auth.user?.username);
        String fullname = auth.user?.username ?? '';
        String matricula = auth.user.matricula != ''
            ? auth.user.matricula
            : '0000 0000 0000 0000';

        bool isLoggedIn = auth.isLoggedId;
        bool isMemberCard = auth.user?.isMemberCard ?? false;
        bool isAdmin = auth.user?.isAdmin ?? false;

        return Scaffold(
          extendBody: true,
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
                icon: Icon(
                  FeatherIcons.award,
                  color: LightStyle.paleta[
                    user.isVerified ?
                    'Sucesso'
                    : 'Shadow'
                  ],
                ),
                onPressed: () => _handlerShowVerificado(user.isVerified),
              ),
              isMemberCard
                  ? IconButton(
                      icon: Icon(FeatherIcons.creditCard),
                      onPressed: () => _handlerShowUserCard(),
                    )
                  : Container(),
              IconButton(
                icon: Icon(FeatherIcons.bell),
                onPressed: () => {},
              ),
              isAdmin
                  ? IconButton(
                      icon: Icon(FeatherIcons.sliders),
                      onPressed: () => {} //_handlerScreen(DashboardScreen()),
                      )
                  : Container(),
            ],
          ),
          body: DraggableScrollableSheet(
            initialChildSize: 1.0,
            builder: (_, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                //padding: const EdgeInsets.symmetric(vertical: 32),
                child: ListView(
                  children: [
                    _showUserCard
                        ? AnimatedContainer(
                            height: _showUserCard ? 268 : 0,
                            duration: Duration(milliseconds: 200),
                            //color: LightStyle.paleta['Background'],

                            decoration: BoxDecoration(
                              color: LightStyle.paleta['Background'],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                            ),

                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 32,
                              ),
                              child: UserCard(
                                tipoCard: TiposCard.MEMBRO,
                                username: fullname,
                                matricula: matricula,
                              ), //UserCard(),
                            ),
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      margin: const EdgeInsets.symmetric(vertical: 32),
                      child: CircleAvatar(
                        radius: 120,
                        backgroundColor: LightStyle.paleta['Primaria'],
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
                    Text(
                      user.tipoMembro != '' ? user.tipoMembro : 'Visitante',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      user.congregacao != ''
                          ? user.congregacao
                          : 'Congregação não informada',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 48),
                    ListItemMenu(
                      title: 'Serviços',
                      icon: FeatherIcons.server,
                      badge: false,
                      page: 1,
                    ),
                    ListItemMenu(
                      title: 'Informações Pessoais',
                      icon: FeatherIcons.user,
                      badge: false,
                      page: 2,
                    ),
                    ListItemMenu(
                      title: 'Endereço',
                      icon: FeatherIcons.mapPin,
                      badge: false,
                      page: 3,
                    ),
                    ListItemMenu(
                      title: 'Contatos',
                      icon: FeatherIcons.phone,
                      badge: false,
                      page: 4,
                    ),
                    ListItemMenu(
                      title: 'Perfil Cristão',
                      icon: FeatherIcons.book,
                      badge: false,
                      page: 5,
                    ),
                    ListItemMenu(
                      title: 'Currículo',
                      icon: FeatherIcons.fileText,
                      badge: false,
                      page: 6,
                    ),
                    ListItemMenu(
                      title: 'Conta',
                      icon: FeatherIcons.key,
                      badge: false,
                      page: 7,
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
                          isLoggedIn,
                          auth,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

/*

SingleChildScrollView(
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
                            backgroundColor: LightStyle.paleta['Primaria'],
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
                        ListItemMenu(
                          title: 'Serviços',
                          icon: FeatherIcons.server,
                          badge: false,
                          page: 1,
                        ),
                        ListItemMenu(
                          title: 'Informações pessoais',
                          icon: FeatherIcons.user,
                          badge: false,
                          page: 2,
                        ),
                        ListItemMenu(
                          title: 'Endereço',
                          icon: FeatherIcons.mapPin,
                          badge: false,
                          page: 3,
                        ),
                        ListItemMenu(
                          title: 'Contatos',
                          icon: FeatherIcons.phone,
                          badge: false,
                          page: 4,
                        ),
                        ListItemMenu(
                          title: 'Perfil Cristão',
                          icon: FeatherIcons.book,
                          badge: false,
                          page: 5,
                        ),
                        ListItemMenu(
                          title: 'Currículo',
                          icon: FeatherIcons.fileText,
                          badge: false,
                          page: 6,
                        ),
                        ListItemMenu(
                          title: 'Conta',
                          icon: FeatherIcons.key,
                          badge: false,
                          page: 7,
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
          )

*/
