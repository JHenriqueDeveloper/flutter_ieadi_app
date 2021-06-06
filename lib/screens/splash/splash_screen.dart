import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_ieadi_app/blocs/blocs.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (prevState, state) => prevState.status != state.status,
        listener: (context, state){
           if (state.status == AuthStatus.unauthenticated) {
            // Go to the Login Screen.
            Timer(
              Duration(seconds: 3), 
              () => Navigator
              .of(context)
              .pushNamed(IntroScreen.routeName),
            );

          } else if (state.status == AuthStatus.authenticated) {
            // Go to the Nav Screen.
            //Precisa mudar para home screen
            //Navigator.of(context).pushNamed(LoginScreen.routeName);
            Timer(
              Duration(seconds: 3), 
              () => Navigator
              .of(context)
              .pushNamed(HomeScreen.routeName),
            );
          }
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'IEADI', 
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 64),
                CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}