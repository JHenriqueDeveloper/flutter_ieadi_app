import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => HomeScreen(),
    );
  }
/*
  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (_, __, ___) => BlocProvider<BottomNavBarCubit>(
        create: (_) => BottomNavBarCubit(),
        child: HomeScreen(),
      ),
    );
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        centerTitle: false,
        title: Text(
          'Olá, Mária',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline5,
        ),
        actions: [
          IconButton(
              icon: Icon(FeatherIcons.creditCard),
              onPressed: () => {} //_handlerShowUserCard(),
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
    );
  }
}
/*
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';

import '../commons/styles.dart';

import 'options_screen.dart';
import '../dashboard/dashboard_screen.dart';

import 'card/user_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen();

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showUserCard = false;

/*
  @override 
  void initState() {
    super.initState();
  }
*/

  File _image;

  Future getImage() async {
    final image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    setState(() {
      _image = image;
    });
  }

  void _handlerShowUserCard() => setState(() => _showUserCard = !_showUserCard);

  @override
  Widget build(BuildContext context) {
    void _handlerScreen(Widget screen) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => screen,
          ),
        );

    void _handlerForm(String form) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OptionsScreen(form),
          ),
        );

    void _handlerSair() => Navigator.pop(context);

    _item({
      String title,
      IconData icon,
      Function onTap,
    }) =>
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: paleta['CinzaClaro'],
                width: 1,
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              title,
              style: textP,
            ),
            //leading: Icon(icon),
            trailing: Icon(icon),
            onTap: onTap,
          ),
        );

    return Scaffold(
      backgroundColor: paleta['Background'],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: paleta['Background'],
        toolbarHeight: 90,
        centerTitle: false,
        title: Text(
          'Olá, Mária',
          textAlign: TextAlign.left,
          style: textH3,
        ),
        actions: [
          IconButton(
            icon: Icon(FeatherIcons.creditCard),
            onPressed: () => _handlerShowUserCard(),
          ),
          IconButton(
            icon: Icon(FeatherIcons.bell),
            onPressed: () => {},
          ),
          IconButton(
            icon: Icon(FeatherIcons.sliders),
            onPressed: () => _handlerScreen(DashboardScreen()),
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
                color: paleta['Background'],
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  child: UserCard(),
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: 40,
                decoration: BoxDecoration(
                  color:
                      _showUserCard ? paleta['BgCard'] : paleta['Background'],
                ),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color:
                        _showUserCard ? paleta['Background'] : paleta['BgCard'],
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
                color: paleta['BgCard'],
                /*
                decoration: BoxDecoration(
                  color: paleta['BgCard'],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                */
                height: MediaQuery.of(context).size.height * 1.5,
                padding: EdgeInsets.symmetric(vertical: 64),
                child: Column(
                  children: [
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
                    SizedBox(height: 48),
                    Text(
                      'Pastor de Área',
                      style: textH4,
                    ),
                    Text(
                      '603838OA-30',
                      style: textP,
                    ),
                    SizedBox(height: 48),
                    _item(
                      title: 'Serviços',
                      icon: FeatherIcons.server,
                      onTap: () => _handlerForm('Serviços'),
                    ),
                    _item(
                      title: 'Informações pessoais',
                      icon: FeatherIcons.user,
                      onTap: () => _handlerForm('Informações Pessoais'),
                    ),
                    _item(
                      title: 'Endereço',
                      icon: FeatherIcons.mapPin,
                      onTap: () => _handlerForm('Endereço'),
                    ),
                    _item(
                      title: 'Contatos',
                      icon: FeatherIcons.phone,
                      onTap: () => _handlerForm('Contatos'),
                    ),
                    _item(
                      title: 'Perfil Cristão',
                      icon: FeatherIcons.book,
                      onTap: () => _handlerForm('Perfil Cristão'),
                    ),
                    _item(
                      title: 'Currículo',
                      icon: FeatherIcons.fileText,
                      onTap: () => _handlerForm('Currículo'),
                    ),
                    _item(
                      title: 'Conta',
                      icon: FeatherIcons.key,
                      onTap: () => _handlerForm('Conta'),
                    ),
                    Container(
                      color: Colors.grey[400],
                      height: 40,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 46,
                      child: TextButton(
                        style: buttonTextRed,
                        child: Text('Sair'),
                        onPressed: () => _handlerSair(),
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
  }
}

*/
