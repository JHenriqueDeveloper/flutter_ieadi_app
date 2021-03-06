import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Theme.of(context).backgroundColor,
          toolbarHeight: 60.sp,
          centerTitle: false,
          title: Text(
            'Secretaria',
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headline5,
          ),
          actions: [
            ProfileImageDashboard(
              onTap: () => context.read<CustomRouter>().setPage(0),
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
                  height: 132.sp,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12.sp),
                      bottomRight: Radius.circular(12.sp),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 24.sp,
                    horizontal: 12.sp,
                  ),
                  child: ListView(
                    //alignment: WrapAlignment.spaceBetween,
                    //runAlignment: WrapAlignment.spaceBetween,
                    scrollDirection: Axis.horizontal,
                    children: [
                      
                      ButtonDashboard(
                        text: 'Chat',
                        icon: FeatherIcons.messageSquare,
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(17),
                      ),
                      ButtonDashboard(
                        text: 'Solicita????es',
                        icon: FeatherIcons.server,
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(17),
                      ),
                      ButtonDashboard(
                        text: 'Batismo',
                        icon: FeatherIcons.calendar,
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(10),
                      ),
                      ButtonDashboard(
                        text: 'Verifica????es',
                        icon: FeatherIcons.award,
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(18),
                      ),
                      ButtonDashboard(
                        text: 'Documentos',
                        icon: FeatherIcons.creditCard,
                        onPressed: () =>
                            context.read<CustomRouter>().setPage(12),
                      ),
                    ],
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
                        title: 'Minist??rio',
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
                        title: '??reas',
                        icon: FeatherIcons.map,
                        badge: false,
                        page: 9,
                      ),
                      ListItemMenu(
                        title: 'Congrega????es',
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
                        title: 'Configura????es',
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
                            child: Text('Solicita????es'),
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
                            child: Text('Verifica????es'),
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
                      title: 'Minist??rio',
                      icon: FeatherIcons.bookOpen,
                      onTap: () => _handlerForm('Minist??rio'),
                    ),
                    _item(
                      title: 'Congrega????es',
                      icon: FeatherIcons.mapPin,
                      onTap: () => _handlerForm('Congrega????es'),
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
