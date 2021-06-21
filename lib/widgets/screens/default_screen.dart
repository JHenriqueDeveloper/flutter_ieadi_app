import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:provider/provider.dart';

class DefaultScreen extends StatelessWidget {
  final String title;
  final int backToPage;
  final List<Widget> children;
  final EdgeInsets padding;
  final GlobalKey<ScaffoldState> key;

  DefaultScreen({
    @required this.title,
    @required this.backToPage,
    this.key,
    this.padding,
    this.children,
  });

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text(
          this.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        leadingWidth: 64,
        leading: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: FloatingActionButton(
            mini: true,
            child: Icon(FeatherIcons.chevronLeft),
            onPressed: () =>
                context.read<CustomRouter>().setPage(this.backToPage),
          ),
        ),
      ),
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
    );
  }
}

/*

class _PessoaisScreenState extends State<PessoaisScreen> {
  final snackBar = SnackBar(
    content: Text('Solicitação Recebida!'),
    backgroundColor: paleta['Primaria'],
  );

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  _selectDate(BuildContext context, String label) async {
    final DateTime picked = await showDatePicker(
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
