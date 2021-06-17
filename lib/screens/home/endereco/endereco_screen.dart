import 'package:flutter/material.dart';

class EnderecoScreen extends StatelessWidget {
  static const String routeName = '/endereco';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => EnderecoScreen(),
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