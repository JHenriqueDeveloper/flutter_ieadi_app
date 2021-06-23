import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EnderecoFormScreen extends StatelessWidget {
  final String form;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  EnderecoFormScreen(this.form);

  final List<String> _ufs = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

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
                      Navigator.of(context).pop();
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
    void _handlerForm() => Navigator.pop(context);

    List<Widget> _forms({
      String form,
      auth,
    }) {
      Map<String, List<Widget>> forms = {
        'CEP': [
          _title(context, 'Informe o CEP da sua residência.'),
          TextFormField(
            keyboardType: TextInputType.number,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'CEP',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (cep) => Validator.rgValidator(cep),
            onSaved: (cep) => auth.user.cep = cep,
            initialValue: auth.user.cep != null ? auth.user.cep : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'UF': [
          _title(context, 'Informe o Estado de sua residência.'),

          for (var uf in _ufs) buttonOption(
            context: context,
            text: uf,
            auth: auth,
            onOption: () => auth.user.uf = uf,
            isActive: auth.user.uf == uf ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Cidade': [
          _title(context, 'Informe o nome da sua cidade.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            
            decoration: InputDecoration(
              labelText: 'Cidade',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (cidade) => Validator.rgValidator(cidade),
            onSaved: (cidade) => auth.user.cidade = cidade,
            initialValue: auth.user.cidade != null ? auth.user.cidade : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Bairro': [
          _title(context, 'Informe o bairro de sua residência.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Bairro',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (bairro) => Validator.rgValidator(bairro),
            onSaved: (bairro) => auth.user.bairro = bairro,
            initialValue: auth.user.bairro != null ? auth.user.bairro : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Logradouro': [
          _title(context, 'Informe o logradouro se houver.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Logradouro',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (logradouro) => Validator.rgValidator(logradouro),
            onSaved: (logradouro) => auth.user.logradouro = logradouro,
            initialValue:
                auth.user.logradouro != null ? auth.user.logradouro : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Complemento': [
          _title(context, 'Informe o complemento do seu endereço.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Complemento',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (complemento) => Validator.rgValidator(complemento),
            onSaved: (complemento) => auth.user.complemento = complemento,
            initialValue: auth.user.complemento != null ? auth.user.complemento : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Numero': [
          _title(context, 'Informe o número da sua residência.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Número',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (numero) => Validator.rgValidator(numero),
            onSaved: (numero) => auth.user.numero = numero,
            initialValue: auth.user.numero != null ? auth.user.numero : null,
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
