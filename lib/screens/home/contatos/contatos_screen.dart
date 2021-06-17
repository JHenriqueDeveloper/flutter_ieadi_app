import 'package:flutter/material.dart';

class ContatosScreen extends StatelessWidget {
  static const String routeName = '/contatos';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ContatosScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        
      ),
    );
  }
}