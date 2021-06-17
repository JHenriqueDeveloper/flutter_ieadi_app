import 'package:flutter/material.dart';

class ServicosScreen extends StatelessWidget {
  static const String routeName = '/servicos';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ServicosScreen(),
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