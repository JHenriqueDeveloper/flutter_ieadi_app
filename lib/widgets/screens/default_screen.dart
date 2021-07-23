import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/config/config.dart';

class DefaultScreen extends StatelessWidget {
  final Widget fab;
  final String title;
  final Widget titleSearch;
  final EdgeInsets padding;
  final List<Widget> children;
  final Widget listView;
  final List<Widget> actions;
  final int backToPage;

  DefaultScreen({
    this.fab,
    this.padding,
    this.children,
    this.listView,
    this.title,
    this.titleSearch,
    this.actions,
    this.backToPage,
  });

  @override
  Widget build(BuildContext context) {
    void _handlerForm() => Navigator.pop(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        extendBody: true,
        floatingActionButton: fab,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          elevation: 0,
          brightness: Brightness.dark,
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          title: this.title != null
              ? Text(
                  this.title,
                  style: Theme.of(context).textTheme.subtitle1,
                )
              : this.titleSearch,
          leadingWidth: 64,
          leading: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FloatingActionButton(
              mini: true,
              child: Icon(FeatherIcons.chevronLeft),
              onPressed: this.backToPage != null
                  ? () => context.read<CustomRouter>().setPage(this.backToPage)
                  : () => _handlerForm(),
            ),
          ),
          actions: actions,
        ),
        body: DraggableScrollableSheet(
            initialChildSize: 1.0,
            builder: (_, ScrollController scrollController) {
              return Container(
                padding: padding != null
                    ? padding
                    : EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: this.children != null 
                ? ListView(children: children)
                : listView,
              );
            }),
      ),
    );
  }
}

/*
class DefaultScreen extends StatelessWidget {
  Widget title;
  int backToPage;
  List<Widget> children;
  List<Widget> actions;
  EdgeInsets padding;
  Widget fab;

  
  Icon searchIcon = new Icon(FeatherIcons.search, color: Colors.white);
  Widget appBarTitle = new Text('',
      style: new TextStyle(
        color: LightStyle.paleta['Branco'],
        fontSize: 14.sp, //20.0,
        fontWeight: FontWeight.w600,
      ));

  TextStyle textStyle = TextStyle(
    color: LightStyle.paleta['Branco'],
    fontSize: 14.sp, //20.0,
    fontWeight: FontWeight.w600,
  );

  DefaultScreen({
    this.title,
    this.backToPage,
    this.children,
    this.actions,
    this.padding,
    this.fab,
  });

  @override
  Widget build(BuildContext context) {
    void _handlerForm() => Navigator.pop(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          title: this.title,
          leadingWidth: 64,
          leading: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FloatingActionButton(
              mini: true,
              child: Icon(FeatherIcons.chevronLeft),
              onPressed: this.backToPage != null
                  ? () => context.read<CustomRouter>().setPage(this.backToPage)
                  : () => _handlerForm(),
            ),
          ),
          actions: actions,
        ),
        floatingActionButton: this.fab,
        body: DraggableScrollableSheet(
            initialChildSize: 1.0,
            builder: (_, ScrollController scrollController) {
              return Container(
                padding: this.padding != null
                    ? this.padding
                    : EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: ListView(
                  children: this.children,
                ),
              );
            }),
      ),
    );
  }
}

/*

class _PessoaisScreenState extends State<PessoaisScreen> {
  snackBar = SnackBar(
    content: Text('Solicitação Recebida!'),
    backgroundColor: paleta['Primaria'],
  );

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  _selectDate(BuildContext context, String label) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2050),
      fieldLabelText: label,
      fieldHintText: 'dd/MM/yyyy',

      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      }

    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  */

  */
