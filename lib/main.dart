//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';

import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(IeadiApp());
}

class IeadiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthRepository(),
      lazy: false, //instancia imediatamente o AuthRepository
      child: MaterialApp(
        title: 'Flutter IEADI app',
        debugShowCheckedModeBanner: false,
        theme: LightStyle.themeLight(),
        initialRoute: '/splash',
        onGenerateRoute: (route) => CustomRouter.getPageRoute(route.name),
      ),
    );
  }
}
