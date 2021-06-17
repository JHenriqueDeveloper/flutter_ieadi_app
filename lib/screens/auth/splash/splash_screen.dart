import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart' as Splash;
import 'package:provider/provider.dart';


import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
            builder: (_, authRepository, __) => Splash.SplashScreen(
                seconds: 3,
                navigateAfterSeconds: authRepository.user != null 
                ? //Navigator.of(context).pushReplacementNamed('/base')
                BaseScreen() //autenticado
                : //Navigator.of(context).pushReplacementNamed('/intro'),
                IntroScreen(), //autenticar
                loaderColor: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  'IEADI', 
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
          );
  }
}

/*

SplashScreen(
        seconds: 3,
        navigateAfterSeconds: IntroScreen(),
        loaderColor: paleta['Primaria'],
        backgroundColor: paleta['Background'],
        title: Text('IEADI', style: textLogo),
      ),

*/

/*

Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'IEADI',
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 64),
              CircularProgressIndicator(),
              TextButton(
                onPressed: () {
                  context.read<CustomRouter>().setPage(1);
                },
                child: Text('NavScreen'),
              ),
            ],
          )

*/
