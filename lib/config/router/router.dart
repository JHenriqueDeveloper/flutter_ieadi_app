import 'package:flutter/material.dart';

import 'package:flutter_ieadi_app/screens/screens.dart';

class CustomRouter {
  PageController _pageController;
  int atualPage = 0;
  int backPage = 0;
  String atualForm = '';
  String atualScreen = '';

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

  String get getForm => atualForm;

  String get getScreen => atualScreen;

  int get getBackPage => backPage;
  set setBackPage(int backPage) => backPage = backPage;

  void setPage(int page, {String form, String screen, int back}) =>
      atualPage != page
          ? {
              atualPage = page,
              form != null ? atualForm = form : null,
              screen != null ? atualScreen = screen : null,
              back != null ? backPage = back : null,
              _pageController.jumpToPage(page),
            }
          : null;
}
