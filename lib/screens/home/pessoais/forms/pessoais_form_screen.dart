import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:google_fonts/google_fonts.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
              fillColor: LightStyle.paleta['PrimariaCinza'],
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
        'Genero': [
          _title(context, 'Você é?'),
          buttonOption(
            context: context,
            text: 'Masculino',
            auth: auth,
            onOption: () => auth.user.genero = 'Masculino',
            isActive: auth.user.genero == 'Masculino' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Feminino',
            auth: auth,
            isActive: auth.user.genero == 'Feminino' ? true : false,
            onOption: () => auth.user.genero = 'Feminino',
          ),
        ],
        'CPF': [
          _title(context, 'Informe seu CPF.'),
          TextFormField(
            keyboardType: TextInputType.number,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            decoration: InputDecoration(
              labelText: 'CPF',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (cpf) => Validator.cpfValidator(cpf),
            onSaved: (cpf) => auth.user.cpf = cpf,
            initialValue: auth.user.cpf != null ? auth.user.cpf : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'RG': [
          _title(context, 'Informe seu RG.'),
          TextFormField(
            keyboardType: TextInputType.number,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: InputDecoration(
              labelText: 'RG',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (rg) => Validator.rgValidator(rg),
            onSaved: (rg) => auth.user.rg = rg,
            initialValue: auth.user.rg != null ? auth.user.rg : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Naturalidade': [
          _title(context, 'Cidade de nascimento.'),
          TextFormField(
            keyboardType: TextInputType.name,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Naturalidade',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (naturalidade) => Validator.rgValidator(naturalidade),
            onSaved: (naturalidade) => auth.user.naturalidade = naturalidade,
            initialValue: auth.user.naturalidade != null ? auth.user.naturalidade : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Nascimento': [
          _title(context, 'Sua data de nascimento.'),
          /*
            _item(
          title: 'Data de Nascimento',
          text: formataData(data: _selectedDate),
          onTap: () => _selectDate(context, 'Data de Nascimento'),
        ),
          */
          TextFormField(
            keyboardType: TextInputType.datetime,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Data de Nascimento',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              DataInputFormatter(),
            ],
            enabled: !auth.isLoading,
            validator: (nascimento) => Validator.rgValidator(nascimento),
            onSaved: (nascimento) => auth.user.dataNascimento = nascimento,
            initialValue: auth.user.dataNascimento != null ? auth.user.dataNascimento : null,
          ),


          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Pai': [
          _title(context, 'Nome completo do seu pai.'),
          TextFormField(
            keyboardType: TextInputType.name,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Nome do Pai',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (pai) => Validator.nameValidator(pai),
            onSaved: (pai) => auth.user.nomePai = pai,
            initialValue: auth.user.nomePai != null ? auth.user.nomePai : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Mae': [
          _title(context, 'Nome completo da sua mãe.'),
          TextFormField(
            keyboardType: TextInputType.name,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Nome da Mãe',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (mae) => Validator.nameValidator(mae),
            onSaved: (mae) => auth.user.nomeMae = mae,
            initialValue: auth.user.nomeMae != null ? auth.user.nomeMae : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Civil': [
          _title(context, 'Você está?'),
          buttonOption(
            context: context,
            text: 'Solteiro',
            auth: auth,
            onOption: () => auth.user.estadoCivil = 'Solteiro',
            isActive: auth.user.estadoCivil == 'Solteiro' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Casado',
            auth: auth,
            onOption: () => auth.user.estadoCivil = 'Casado',
            isActive: auth.user.estadoCivil == 'Casado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Divorciado',
            auth: auth,
            onOption: () => auth.user.estadoCivil = 'Divorciado',
            isActive: auth.user.estadoCivil == 'Divorciado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Emancebado',
            auth: auth,
            onOption: () => auth.user.estadoCivil = 'Emancebado',
            isActive: auth.user.estadoCivil == 'Emancebado' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Viúvo',
            auth: auth,
            onOption: () => auth.user.estadoCivil = 'Viúvo',
            isActive: auth.user.estadoCivil == 'Viúvo' ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Sangue': [
          _title(context, 'Informe seu tipo sanguíneo.'),
          buttonOption(
            context: context,
            text: 'A+',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'A+',
            isActive: auth.user.tipoSanguineo == 'A+' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'A-',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'A-',
            isActive: auth.user.tipoSanguineo == 'A-' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'B+',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'B+',
            isActive: auth.user.tipoSanguineo == 'B+' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'AB+',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'AB+',
            isActive: auth.user.tipoSanguineo == 'AB+' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'AB-',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'AB-',
            isActive: auth.user.tipoSanguineo == 'AB-' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'O+',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'O+',
            isActive: auth.user.tipoSanguineo == 'O+' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'O-',
            auth: auth,
            onOption: () => auth.user.tipoSanguineo = 'O-',
            isActive: auth.user.tipoSanguineo == 'O-' ? true : false,
          ),
        ],
        'Titulo': [
          _title(context, 'Informe seu Título de Eleitor.'),
          TextFormField(
            keyboardType: TextInputType.number,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Número do Título de Eleitor',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            enabled: !auth.isLoading,
            validator: (titulo) => Validator.tituloValidator(titulo),
            onSaved: (titulo) => auth.user.tituloEleitor = titulo,
            initialValue: auth.user.tituloEleitor != null ? auth.user.tituloEleitor : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Zona': [
          _title(context, 'Informe a sua Zona Eleitoral.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Zona Eleitoral',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (zona) => Validator.zonaValidator(zona),
            onSaved: (zona) => auth.user.zonaEleitor = zona,
            initialValue: auth.user.zonaEleitor != null ? auth.user.zonaEleitor : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Secao': [
          _title(context, 'Informe sua Seção Eleitoral.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 50,
            maxLines: 1,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Seção Eleitoral',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (secao) => Validator.zonaValidator(secao),
            onSaved: (secao) => auth.user.secaoEleitor = secao,
            initialValue: auth.user.secaoEleitor != null ? auth.user.secaoEleitor : null,
          ),
          SizedBox(height: 16),
          _save(
            context: context,
            auth: auth,
          ),
        ],
        'Especial': [
          _title(context, 'Você é portador de alguma necessidade especial?'),
          buttonOption(
            context: context,
            text: 'Sim',
            auth: auth,
            onOption: () => auth.user.isPortadorNecessidade = true,
            isActive: auth.user.isPortadorNecessidade ? true : false,
          ),
          SizedBox(height: 16),
           buttonOption(
            context: context,
            text: 'Não',
            auth: auth,
            onOption: () => auth.user.isPortadorNecessidade = false,
            isActive: !auth.user.isPortadorNecessidade ? true : false,
          ),
          SizedBox(height: 16),
        ],
        'Tipo Necessidade': [
          _title(context, 'Qual é o tipo da sua necessidade especial?'),
          buttonOption(
            context: context,
            text: 'Visual',
            auth: auth,
            onOption: () => auth.user.tipoNecessidade = 'Visual',
            isActive: auth.user.tipoNecessidade == 'Visual' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Auditiva',
            auth: auth,
            onOption: () => auth.user.tipoNecessidade = 'Auditiva',
            isActive: auth.user.tipoNecessidade == 'Auditiva' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Mental',
            auth: auth,
            onOption: () => auth.user.tipoNecessidade = 'Mental',
            isActive: auth.user.tipoNecessidade == 'Mental' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Fisica',
            auth: auth,
            onOption: () => auth.user.tipoNecessidade = 'Fisica',
            isActive: auth.user.tipoNecessidade == 'Fisica' ? true : false,
          ),
          SizedBox(height: 16),
          buttonOption(
            context: context,
            text: 'Outra',
            auth: auth,
            onOption: () => auth.user.tipoNecessidade = 'Outra',
            isActive: auth.user.tipoNecessidade == 'Outra' ? true : false,
          ),
          
        ],
        'Descricao Necessidade': [
          _title(context, 'Descreva brevemente quais são as suas limitações para \nque possamos \nmelhor servi-lo.'),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 500,
            maxLines: 10,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Descreva sua necessidade.',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !auth.isLoading,
            validator: (descri) => Validator.descricaoValidator(descri),
            onSaved: (descri) => auth.user.descricaoNecessidade = descri,
            initialValue: auth.user.descricaoNecessidade != null ? auth.user.descricaoNecessidade : null,
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
