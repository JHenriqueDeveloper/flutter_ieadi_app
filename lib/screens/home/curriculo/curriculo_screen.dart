import 'package:flutter/material.dart';

class CurriculoScreen extends StatelessWidget {
  static const String routeName = '/curriculo';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => CurriculoScreen(),
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