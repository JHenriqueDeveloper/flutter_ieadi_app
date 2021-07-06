import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/screens/secretaria/dashboard/widgets/dashboard_widgets.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../config/config.dart';
import '../../../style/style.dart';
import '../../../widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).backgroundColor,
          toolbarHeight: 60.sp,
          centerTitle: false,
          title: Text(
            'Secretaria',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: [
            /*
            IconButton(
              icon: Icon(FeatherIcons.messageSquare),
              onPressed: () => _handlerScreen(HomeScreen()),
            ),
            */

            ProfileImageDashboard(
              onTap: () => context.read<CustomRouter>().setPage(0),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 128.sp,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).backgroundColor,
                  padding: EdgeInsets.symmetric(
                    vertical: 24.sp,
                    horizontal: 24.sp,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    children: [
                      ButtonDashboard(
                        text: 'Solicitaçãoes',
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(17),
                      ),
                      ButtonDashboard(
                        text: 'Certificados',
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(10),
                      ),
                      ButtonDashboard(
                        text: 'Verificações',
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(18),
                      ),
                      ButtonDashboard(
                        text: 'Documentos',
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(12),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: LightStyle.paleta['BgCard'],
                  child: Container(
                    height: 12.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24.sp),
                        bottomRight: Radius.circular(24.sp),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: LightStyle.paleta['BgCard'],
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.only(
                    top: 32,
                    bottom: 64,
                  ),
                  child: Column(
                    children: [
                      //SizedBox(height: 48),
                      ListItemMenu(
                        title: 'Ministério',
                        icon: FeatherIcons.bookOpen,
                        badge: false,
                        page: 14,
                      ),
                      ListItemMenu(
                        title: 'Setores',
                        icon: FeatherIcons.mapPin,
                        badge: false,
                        page: 16,
                      ),
                      ListItemMenu(
                        title: 'Áreas',
                        icon: FeatherIcons.map,
                        badge: false,
                        page: 9,
                      ),
                      ListItemMenu(
                        title: 'Congregações',
                        icon: FeatherIcons.home,
                        badge: false,
                        page: 11,
                      ),
                      ListItemMenu(
                        title: 'Membros',
                        icon: FeatherIcons.users,
                        badge: false,
                        page: 13,
                      ),
                      ListItemMenu(
                        title: 'Configurações',
                        icon: FeatherIcons.settings,
                        badge: false,
                        page: 15,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
class DashboardScreen extends StatelessWidget{
  Widget build(BuildContext context) {

    void _handlerScreen(Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );

    void _handlerVoltar() => Navigator.pop(context);

     void _handlerForm(String lista) => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Listagens(lista),
          ),
        );

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
          'Secretaria',
          textAlign: TextAlign.left,
          style: textH3,
        ),
        actions: [
          /*
          IconButton(
            icon: Icon(FeatherIcons.messageSquare),
            onPressed: () => _handlerScreen(HomeScreen()),
          ),
          */

          Container(
            margin: EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(1.0),
            height: 32,
            decoration: new BoxDecoration(
              color: paleta['Branco'], 
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              child: CircleAvatar(
                //radius: 32,
                backgroundColor: paleta['Primaria'],
                backgroundImage: AssetImage('user.jpeg'),
              ),
              onTap: () => _handlerVoltar(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 268,
                color: paleta['Background'],
                padding: EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                         width: 160,
                          height: 80,
                          child: ElevatedButton(
                            child: Text('Solicitações'),
                            style: buttonDashboard,
                            onPressed: () => {},
                          ),
                        ),

                        Spacer(),

                        SizedBox(
                          width: 160,
                          height: 80,
                          child: ElevatedButton(
                            child: Text('Certificados'),
                            style: buttonDashboard,
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    ),

                    Spacer(),

                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          height: 80,
                          child: ElevatedButton(
                            child: Text('Verificações'),
                            style: buttonDashboard,
                            onPressed: () => {},
                          ),
                        ),

                        Spacer(),

                        SizedBox(
                          width: 160,
                          height: 80,
                          child: ElevatedButton(
                            child: Text('Documentos'),
                            style: buttonDashboard,
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                color: paleta['BgCard'],
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: paleta['Background'],
                    
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),

              Container(
                color: paleta['BgCard'],
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                  top: 32,
                  bottom: 64,
                ),
                child: Column(
                  children: [
                     //SizedBox(height: 48),
                    _item(
                      title: 'Ministério',
                      icon: FeatherIcons.bookOpen,
                      onTap: () => _handlerForm('Ministério'),
                    ),
                    _item(
                      title: 'Congregações',
                      icon: FeatherIcons.mapPin,
                      onTap: () => _handlerForm('Congregações'),
                    ),
                    _item(
                      title: 'Pastores',
                      icon: FeatherIcons.book,
                      onTap: () => _handlerForm('Pastores'),
                    ),
                    _item(
                      title: 'Membros',
                      icon: FeatherIcons.users,
                      onTap: () => _handlerForm('Membros'),
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
