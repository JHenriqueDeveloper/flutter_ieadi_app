import 'package:flutter/material.dart';

import 'package:flutter_ieadi_app/screens/screens.dart';

class CustomRouter {
  PageController _pageController;
  int atualPage = 0;

  CustomRouter(this._pageController);

  static MaterialPageRoute getPageRoute(String routeName) {
          switch (routeName) {
            case '/splash':
              return MaterialPageRoute(
                builder: (_) => SplashScreen(),
              );
            case '/login':
              return MaterialPageRoute(
                builder: (_) => LoginScreen(),
              );
            case '/signup':
              return MaterialPageRoute(
                builder: (_) => SignupScreen(),
              );
            case '/base':
              return MaterialPageRoute(
                builder: (_) => BaseScreen(),
              );
            case '/intro':
            default:
              return MaterialPageRoute(
                builder: (_) => IntroScreen(),
              );
          }
        }

  void setPage(int page) => atualPage != page
  ? {
    atualPage = page,
    _pageController.jumpToPage(page),
    /*
    _pageController.animateToPage(
      page, 
      duration: Duration(milliseconds: 300), 
      curve: Curves.slowMiddle,
    )
    */
  }
  : null;


}
