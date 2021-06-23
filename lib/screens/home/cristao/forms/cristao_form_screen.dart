import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CristaoFormScreen extends StatelessWidget {
  final String form;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CristaoFormScreen(this.form);

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
        'Dizimista': [
          _title(context, 'Você é dizimista?'),
          buttonOption(
            context: context,
            text: 'Sim',
            auth: auth,
            onOption: () => auth.user.isDizimista = true,
            isActive: auth.user.isDizimista ? true : false,
          ),
          SizedBox(height: 16),
         buttonOption(
            context: context,
            text: 'Não',
            auth: auth,
            onOption: () => auth.user.isDizimista = false,
            isActive: auth.user.isDizimista ? false : true,
          ),
        ],


        'Congregacao': [
          _title(context, 'Sua congregação.'),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Afiliacao': [
          _title(context, 'Você é?'),
          buttonOption(
            context: context,
            text: 'Membro',
            auth: auth,
            onOption: () => auth.user.tipoMembro = 'Membro',
            isActive: auth.user.tipoMembro == 'Membro' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Congregado',
            auth: auth,
            onOption: () => auth.user.tipoMembro = 'Congregado',
            isActive: auth.user.tipoMembro == 'Congregado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Criança',
            auth: auth,
            onOption: () => auth.user.tipoMembro = 'Criança',
            isActive: auth.user.tipoMembro == 'Criança' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Amigo do Evangelho',
            auth: auth,
            onOption: () => auth.user.tipoMembro = 'Amigo do Evangelho',
            isActive: auth.user.tipoMembro == 'Amigo do Evangelho' ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Situacao': [
          _title(context, 'Qual é a sua situação atual?'),
          buttonOption(
            context: context,
            text: 'Comunhão',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Comunhão',
            isActive: auth.user.situacaoMembro == 'Comunhão' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Afastado',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Afastado',
            isActive: auth.user.situacaoMembro == 'Afastado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Disciplinado',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Disciplinado',
            isActive: auth.user.situacaoMembro == 'Disciplinado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Mudou de Campo',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Mudou de Campo',
            isActive: auth.user.situacaoMembro == 'Mudou de Campo' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Mudou de Ministério',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Mudou de Ministério',
            isActive: auth.user.situacaoMembro == 'Mudou de Ministério' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Falecido',
            auth: auth,
            onOption: () => auth.user.situacaoMembro = 'Falecido',
            isActive: auth.user.situacaoMembro == 'Falecido' ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Procedencia': [
          _title(context, 'A sua afiliação é procedente de?'),
          buttonOption(
            context: context,
            text: 'Batizado no Campo',
            auth: auth,
            onOption: () => auth.user.procedenciaMembro = 'Batizado no Campo',
            isActive: auth.user.procedenciaMembro == 'Batizado no Campo' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Carta de Mudança de Outro Ministério',
            auth: auth,
            onOption: () => auth.user.procedenciaMembro = 'Carta de Mudança de Outro Ministério',
            isActive: auth.user.procedenciaMembro == 'Carta de Mudança de Outro Ministério' ? true : false,
          ),
          SizedBox(height: 16),
           buttonOption(
            context: context,
            text: 'Carta de Mudança do mesmo Ministério',
            auth: auth,
            onOption: () => auth.user.procedenciaMembro = 'Carta de Mudança do mesmo Ministério',
            isActive: auth.user.procedenciaMembro == 'Carta de Mudança do mesmo Ministério' ? true : false,
          ),
          SizedBox(height: 16),
           buttonOption(
            context: context,
            text: 'Aclamação',
            auth: auth,
            onOption: () => auth.user.procedenciaMembro = 'Aclamação',
            isActive: auth.user.procedenciaMembro == 'Aclamação' ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Origem': [
          _title(context, 'Informe de onde você é.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Origem',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.origemMembro = value,
            initialValue: auth.user.origemMembro != null ? auth.user.origemMembro : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Mudanca': [
          _title(context, 'Quando você mudou para esse Ministério.'),
          TextFormField(
            keyboardType: TextInputType.datetime,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Data de Mudança',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.dataMudanca = value,
            initialValue: auth.user.dataMudanca != null ? auth.user.dataMudanca : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Local_Conversao': [
          _title(context, 'Onde você aceitou a Jesus.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Local de Conversão',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.localConversao = value,
            initialValue: auth.user.localConversao != null ? auth.user.localConversao : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Data_Conversao': [
          _title(context, 'O dia em que você aceitou a Jesus.'),
          TextFormField(
            keyboardType: TextInputType.datetime,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Data de Conversão',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.dataConversao = value,
            initialValue: auth.user.dataConversao != null ? auth.user.dataConversao : null,
          ),


          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Local_Aguas': [
          _title(context, 'Onde você foi batizado em águas.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Local de Batismo em Águas',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.localBatismoAguas = value,
            initialValue: auth.user.localBatismoAguas != null ? auth.user.localBatismoAguas : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Data_Aguas': [
          _title(context, 'O dia em que você foi batizado em águas.'),
          TextFormField(
            keyboardType: TextInputType.datetime,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Data de Batismo em Águas',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.dataBatismoAguas = value,
            initialValue: auth.user.dataBatismoAguas != null ? auth.user.dataBatismoAguas : null,
          ),


          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Local_Espirito': [
          _title(context, 'Onde você foi batizado no Espirito Santo.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Local de Batismo no Espirito',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.localBatismoEspiritoSanto = value,
            initialValue: auth.user.localBatismoEspiritoSanto != null ? auth.user.localBatismoEspiritoSanto : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Data_Espirito': [
          _title(context, 'O dia em que você foi batizado no Espirito Santo.'),
          TextFormField(
            keyboardType: TextInputType.datetime,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Data de Batismo no Espirito',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => auth.user.dataBatismoEspiritoSanto = value,
            initialValue: auth.user.dataBatismoEspiritoSanto != null ? auth.user.dataBatismoEspiritoSanto : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Bio_Cristao': [
          _title(context, 'Observações a respeito do membro.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 500,
            maxLines: 10,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: '.',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: false,
            validator: (descri) => Validator.descricaoValidator(descri),
            onSaved: (descri) => auth.user.bio = descri,
            initialValue: auth.user.bio != null ? auth.user.bio : null,
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
