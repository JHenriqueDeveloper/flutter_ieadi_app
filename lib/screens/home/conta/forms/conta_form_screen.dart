import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContaFormScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final int page = 7;

  void _handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(page);

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
                        _handlerForm(context);
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

  Widget buttonOption({
    BuildContext context,
    auth,
    String text,
    Function onOption,
    bool isActive = true,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 46,
        child: ElevatedButton(
          onPressed: !auth.isLoading
              ? () {
                  onOption();

                  auth.update(
                    user: auth.user,
                    onFail: (e) => _snackBar(
                      context: context,
                      msg: 'Falha ao atualizar os dados: $e',
                      isSuccess: false,
                    ),
                    onSuccess: (uid) {
                      _handlerForm(context);
                      _snackBar(context: context, msg: 'Dados atualizados');
                    },
                  );
                }
              : () {},
          style: isActive
              ? null
              : ElevatedButton.styleFrom(
                  primary: LightStyle.paleta['PrimariaCinza'],
                  shadowColor: Colors.transparent,
                ),
          child: !auth.isLoading
              ? Text(text,
                  style: isActive
                      ? null
                      : GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: LightStyle.paleta['Cinza'],
                          letterSpacing: 0,
                        ))
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

    List<Widget> _forms({
      String form,
      auth,
    }) {
      Map<String, List<Widget>> forms = {
        'Fixo': [
          _title(context, 'Informe o telefone fixo.'),
          TextFormField(
            keyboardType: TextInputType.phone,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Telefone Fixo',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (fixo) => Validator.rgValidator(fixo),
            onSaved: (fixo) => auth.user.numeroFixo = fixo,
            initialValue:
                auth.user.numeroFixo != null ? auth.user.numeroFixo : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Celular': [
          _title(context, 'Informe o telefone celular.'),
          TextFormField(
            keyboardType: TextInputType.phone,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Telefone Celular',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TelefoneInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (celular) => Validator.rgValidator(celular),
            onSaved: (celular) => auth.user.numeroCelular = celular,
            initialValue: auth.user.numeroCelular != null
                ? auth.user.numeroCelular
                : null,
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
              onPressed: () => _handlerForm(context),
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
                    form: context.read<CustomRouter>().getForm,
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
