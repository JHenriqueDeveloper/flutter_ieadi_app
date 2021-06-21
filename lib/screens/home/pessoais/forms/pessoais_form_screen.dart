import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:provider/provider.dart';

class PessoaisFormScreen extends StatelessWidget {
  final String form;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  PessoaisFormScreen(this.form);

  _snackBar({
    BuildContext context,
    String msg,
    bool isSuccess = true,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess
            ? LightStyle.paleta['Sucesso']
            : Theme.of(context).errorColor,
      ));

  Widget _title(BuildContext context, String title) => Container(
        padding: const EdgeInsets.only(
          bottom: 32,
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline6,
        ),
      );

  Widget _save({
    BuildContext context,
    auth,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 46,
        child: ElevatedButton(
          onPressed: !auth.isLoading
              ? () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    auth.update(
                      user: auth.user,
                      onFail: (e) => _snackBar(
                        context: context,
                        msg: 'Falha ao atualizar os dados: $e',
                        isSuccess: false,
                      ),
                      onSuccess: (uid) {
                        Navigator.of(context).pop();
                        _snackBar(context: context, msg: 'Dados atualizados');
                      },
                    );
                  }
                }
              : () {},
          child: !auth.isLoading
              ? Text('Continuar')
              : SizedBox(
                  height: 28,
                  width: 28,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    void _handlerForm() => Navigator.pop(context);

    List<Widget> _forms({
      String form,
      auth,
    }) {
      Map<String, List<Widget>> forms = {
        'Nome': [
          _title(context, 'Seu nome completo.'),
          TextFormField(
            keyboardType: TextInputType.name,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Nome Completo',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaClaro'],
            ),
            enabled: !auth.isLoading,
            validator: (userName) => Validator.nameValidator(userName),
            onSaved: (username) => auth.user.setUsername = username,
            initialValue:
                auth.user.username != null ? auth.user.username : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
      };
      return forms[form];
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).canvasColor,
        extendBody: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 90,
          elevation: 0,
          brightness: Brightness.dark,
          backgroundColor: Theme.of(context).canvasColor,
          leadingWidth: 64,
          leading: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: FloatingActionButton(
              mini: true,
              child: Icon(FeatherIcons.chevronLeft),
              onPressed: () => _handlerForm(),
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
            ),
            child: Consumer<AuthRepository>(
              builder: (_, auth, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _forms(
                    form: this.form,
                    auth: auth,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/*
Map<String, Widget> _form = {
      'nome': Container(
        child: Column(
          children: [
            Text('Informe seu nome Completo.'),
            TextFormField(),
            ElevatedButton(
              onPressed: !authRepository.isLoading
                  ? () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        context.read<AuthRepository>().signUp(
                              user: this.user,
                              onFail: (e) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Falha ao efetuar o cadastro: $e'),
                                  backgroundColor: Theme.of(context).errorColor,
                                ),
                              ),
                              onSuccess: (uid) {
                                Navigator.of(context)
                                    .pushReplacementNamed('/base');
                              },
                            );
                      }
                      //context.read<CustomRouter>().setPage(4);
                    }
                  : () {},
              child: !authRepository.isLoading
                  ? Text('Continuar')
                  : SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    };
*/
