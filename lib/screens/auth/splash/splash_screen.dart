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
            ? BaseScreen() //autenticado
            : IntroScreen(), //autenticar
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
Consumer<AuthRepository>(
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
*/
