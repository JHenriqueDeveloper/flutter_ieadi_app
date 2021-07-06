import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ieadi_app/helpers/image_helper.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/util.dart';
import '../../../../helpers/validator.dart';
import '../../../../models/models.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class MembroForm extends StatefulWidget {
  final UserModel membro;

  MembroForm({
    this.membro,
  });

  _MembroFormState createState() => _MembroFormState();
}

class _MembroFormState extends State<MembroForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UserModel _membro = new UserModel();
  String _title;
  bool _isAddMembro;

  @override
  void initState() {
    super.initState();
    if (widget.membro != null) {
      _membro = widget.membro;
      _title = 'Atualizar membro';
      _isAddMembro = false;
    } else {
      _title = 'Adicionar membro';
      _isAddMembro = true;
    }
  }

  File profileImage;
  void _selectImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Foto de perfil',
    );
    if (pickedFile != null) {
      setState(() {
        profileImage = pickedFile;
      });
    }
  }

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

  _dropList(List<String> list) {
    return list
        .map(
          (String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: GoogleFonts.roboto(
                fontSize: 16,
                height: 1.5,
                letterSpacing: 0,
                color: LightStyle.paleta['Cinza'],
              ),
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _listCongreg({
    BuildContext context,
  }) {
    List<CongregModel> list = context.read<CongregRepository>().getListCongregs;
    return list.map<DropdownMenuItem<String>>((CongregModel congreg) {
      return DropdownMenuItem(
        value: congreg.id,
        child: Text(
          congreg.nome,
          style: GoogleFonts.roboto(
            fontSize: 16,
            height: 1.5,
            letterSpacing: 0,
            color: LightStyle.paleta['Cinza'],
          ),
        ),
      );
    }).toList();
  }

  Widget _buttonSave({
    BuildContext context,
    state,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 46,
        child: ElevatedButton(
          onPressed: !state.isLoading
              ? () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (_isAddMembro) {
                      context.read<MembroRepository>().addMembro(
                            membro: _membro,
                            image: profileImage ?? null,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel adicionar o membro: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'Nova membro adicionado com successo!');
                            },
                          );
                    } else {
                      context.read<MembroRepository>().updateMembro(
                            membro: _membro,
                            image: profileImage ?? null,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel atualizar o membro: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'membro atualizado com sucesso!');
                            },
                          );
                    }
                  }
                }
              : () {
                  print('Teste de button');
                },
          child: !state.isLoading
              ? Text(_isAddMembro ? 'Adicionar' : 'Atualizar')
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
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        String membroNome =
            _membro?.username != '' ? firstName(_membro?.username) : '';

        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: membroNome.length > 0 ? membroNome : _title,
          form: [
            UploadImage(
              onTap: () => _selectImage(context),
              isLoading: false,
              image: profileImage,
              imageUrl: _membro?.profileImageUrl ?? '',
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Informações Pessoais',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Nome completo',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.username = value,
              initialValue: _membro?.username ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Gênero',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.genero,
                hint: Text('Não Informado'),
                onChanged: (value) => setState(() => _membro.genero = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(generos_list),
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'CPF',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              enabled: !state.isLoading,
              validator: (value) => Validator.cpfValidator(value),
              onSaved: (value) => _membro.cpf = value,
              initialValue: _membro?.cpf ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'RG',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => _membro.rg = value,
              initialValue: _membro?.rg ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.text,
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.naturalidade = value,
              initialValue: _membro?.naturalidade ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.datetime,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Data de nascimento',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.dataNascimento = value,
              initialValue: _membro?.dataNascimento ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Nome do pai',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.nomePai = value,
              initialValue: _membro?.nomePai ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Nome da mãe',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.nomeMae = value,
              initialValue: _membro?.nomeMae ?? null,
            ),
            ListTile(
              title: Text(
                'Estado civil',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.estadoCivil,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.estadoCivil = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(civil_list),
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Tipo Sanguineo',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.tipoSanguineo,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.tipoSanguineo = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(sangue_list),
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Titulo de Eleitor',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.tituloEleitor = value,
              initialValue: _membro?.tituloEleitor ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.zonaEleitor = value,
              initialValue: _membro?.zonaEleitor ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _membro.secaoEleitor = value,
              initialValue: _membro?.secaoEleitor ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Portador de \nnecessidade Especial?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _membro.isPortadorNecessidade = value),
                value: _membro?.isPortadorNecessidade ?? false,
              ),
            ),
            _membro?.isPortadorNecessidade == true
                ? SizedBox(height: 16)
                : SizedBox(),
            _membro?.isPortadorNecessidade == true
                ? ListTile(
                    title: Text(
                      'Tipo de \nnecessidade especial',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabled: !state.isLoading,
                    trailing: DropdownButton(
                      underline:
                          Container(height: 0, color: Colors.transparent),
                      value: _membro?.tipoNecessidade,
                      hint: Text('Não Informado'),
                      onChanged: (value) =>
                          setState(() => _membro.tipoNecessidade = value),
                      style: Theme.of(context).textTheme.bodyText1,
                      items: _dropList(necessidades_list),
                    ),
                  )
                : SizedBox(),
            _membro?.isPortadorNecessidade == true
                ? SizedBox(height: 32)
                : SizedBox(),
            _membro?.isPortadorNecessidade == true
                ? TextFormField(
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    maxLength: 500,
                    maxLines: 10,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      labelText: 'Descrição da necessidade.',
                      labelStyle: Theme.of(context).textTheme.bodyText1,
                      fillColor: LightStyle.paleta['PrimariaCinza'],
                    ),
                    enabled: !state.isLoading,
                    onSaved: (value) => _membro.descricaoNecessidade = value,
                    initialValue: _membro?.descricaoNecessidade ?? null,
                  )
                : SizedBox(),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Endereço',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.cep = value,
              initialValue: _membro?.cep ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Estado',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.uf,
                hint: Text('UF'),
                onChanged: (value) => setState(() => _membro.uf = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(uf_list),
              ),
            ),
            SizedBox(height: 32),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.cidade = value,
              initialValue: _membro?.cidade ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.bairro = value,
              initialValue: _membro?.bairro ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.logradouro = value,
              initialValue: _membro?.logradouro ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.complemento = value,
              initialValue: _membro?.complemento ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.numero = value,
              initialValue: _membro?.numero ?? null,
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Contatos',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Telefone fixo',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.numeroFixo = value,
              initialValue: _membro?.numeroFixo ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.phone,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Telefone celular',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.numeroCelular = value,
              initialValue: _membro?.numeroCelular ?? null,
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Perfil Cristão',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'É dizimista?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _membro.isDizimista = value),
                value: _membro?.isDizimista ?? false,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Congregação',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.congregacao != null
                    ? _membro?.congregacao != ''
                        ? _membro?.congregacao
                        : null
                    : null,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.congregacao = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listCongreg(context: context),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Afiliação',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.tipoMembro,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.tipoMembro = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(tipos_membros), //_dropDownTipoMembros,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Situação do Membro',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.situacaoMembro,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.situacaoMembro = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(situacao_membros), //_dropDownTipoMembros,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Procedencia',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              subtitle: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _membro?.procedenciaMembro,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => _membro.procedenciaMembro = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropList(procedencias), //_dropDownTipoMembros,
              ),
              trailing: null,
            ),
            SizedBox(height: 32),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.origemMembro = value,
              initialValue: _membro?.origemMembro ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.datetime,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Data de mudança',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.dataMudanca = value,
              initialValue: _membro?.dataMudanca ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.localConversao = value,
              initialValue: _membro?.localConversao ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.datetime,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Data de conversão',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.dataConversao = value,
              initialValue: _membro?.dataConversao ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Local Batismo em Águas',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => _membro.localBatismoAguas = value,
              initialValue: _membro?.localBatismoAguas ?? null,
            ),
            SizedBox(height: 16),
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
              enabled: !state.isLoading,
              onSaved: (value) => _membro.dataBatismoAguas = value,
              initialValue: _membro?.dataBatismoAguas ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Local Batismo Espirito Santo',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => _membro.localBatismoEspiritoSanto = value,
              initialValue: _membro?.localBatismoEspiritoSanto ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.datetime,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Data de Batismo no Espirito Santo',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => _membro.dataBatismoEspiritoSanto = value,
              initialValue: _membro?.dataBatismoEspiritoSanto ?? null,
            ),
            SizedBox(height: 16),
            TextFormField(
              keyboardType: TextInputType.text,
              autocorrect: false,
              maxLength: 500,
              maxLines: 10,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Biografia do Membro',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => _membro?.bio = value,
              initialValue: _membro?.bio ?? null,
            ),
            SizedBox(height: 32),
            _buttonSave(
              context: context,
              state: state,
            ),
          ],
        );
      },
    );
  }
}
