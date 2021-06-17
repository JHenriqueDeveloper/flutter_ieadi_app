import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {

  static const String routeName = '/dashboard';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => DashboardScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}