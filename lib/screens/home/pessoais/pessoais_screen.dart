import 'package:flutter/material.dart';

class PessoaisScreen extends StatelessWidget {
  static const String routeName = '/pessoais';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PessoaisScreen(),
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