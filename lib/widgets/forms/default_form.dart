import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../style/style.dart';

class DefaultForm extends StatelessWidget {
  final List<Widget> form;
  final GlobalKey<FormState> formKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;

  DefaultForm({
    this.form,
    this.formKey,
    this.scaffoldKey,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    void _handlerForm() => Navigator.pop(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: this.scaffoldKey,
        backgroundColor: Theme.of(context).canvasColor,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).canvasColor,
          leadingWidth: 64,
          title: Text(
            this.title,
            textAlign: TextAlign.center,
            style: TextStyle(
            color: LightStyle.paleta['Background'],
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
          ),
          leading: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: FloatingActionButton(
              mini: true,
              child: Icon(FeatherIcons.chevronLeft),
              onPressed: () => _handlerForm(),
            ),
          ),
        ),
        body: Form(
          key: this.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: this.form,
            ),
          ),
        ),
      ),
    );
  }
}
