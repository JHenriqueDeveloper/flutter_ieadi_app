import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:sizer/sizer.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;
  final bool appbar;
  final String navigateTo;

  AuthScreen({
    this.appbar,
    this.child,
    this.navigateTo,
  });

  AppBar _appBar(context) => AppBar(
        leadingWidth: 40.sp, //16.w, //64,
        leading: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 8.sp, //4.w, //16,
          ),
          child: FloatingActionButton(
            mini: true,
            child: Icon(FeatherIcons.chevronLeft),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed(this.navigateTo),
          ),
        ),
      );

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: this.appbar ? _appBar(context) : null,
        body: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: 16.sp, //32,
            vertical: 32.sp, //64,
          ),
          child: SingleChildScrollView(
            //color: Colors.grey,
            child: this.child,
          ),
        ),
      ),
    );
  }
}
