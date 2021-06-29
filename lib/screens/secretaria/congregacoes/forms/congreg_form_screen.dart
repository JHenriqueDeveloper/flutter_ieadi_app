import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ieadi_app/helpers/image_helper.dart';
import 'package:flutter_ieadi_app/models/congreg/congreg_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/util.dart';
import '../../../../helpers/validator.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class CongregForm extends StatefulWidget {
  final CongregModel congreg;

  CongregForm({
    this.congreg,
  });

  _CongregFormState createState() => _CongregFormState();
}

class _CongregFormState extends State<CongregForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static const _ufs = uf_list;

  CongregModel _congreg = new CongregModel();
  String _title;
  bool _isAddCong;

  @override
  void initState() {
    super.initState();
    if (widget.congreg != null) {
      _congreg = widget.congreg;
      _title = 'Atualizar Congregação';
      _isAddCong = false;
    } else {
      _title = 'Adicionar Congregação';
      _isAddCong = true;
    }
  }

  File profileImage;
  void _selectImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Foto da Congregação',
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

  final List<DropdownMenuItem<String>> _dropDownUf = _ufs
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
                    if (_isAddCong) {
                      context.read<CongregRepository>().addCongreg(
                            congreg: _congreg,
                            image: profileImage ?? null,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel adicionar congregação: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg:
                                      'Nova congregação adicionada com successo!');
                            },
                          );
                    } else {
                      context.read<CongregRepository>().updateCongreg(
                            congreg: _congreg,
                            image: profileImage ?? null,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg:
                                  'Não foi possivel atualizar a congregação: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'Congregação atualizada com sucesso!');
                            },
                          );
                    }
                  }
                }
              : () {},
          child: !state.isLoading
              ? Text(_isAddCong ? 'Adicionar' : 'Atualizar')
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
    return Consumer<CongregRepository>(
      builder: (_, state, __) {
        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: _title,
          form: [
            UploadImage(
              onTap: () => _selectImage(context),
              isLoading: false,
              image: profileImage,
              imageUrl: _congreg?.profileImageUrl ?? '',
            ),
            SizedBox(height: 48),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Nome da Congregação',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setNome = value,
              initialValue: _congreg?.nome ?? null,
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
                labelText: 'Fundação',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                DataInputFormatter(),
              ],
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setDataFundacao = value,
              initialValue: _congreg?.dataFundacao ?? null,
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
                labelText: 'Unidade Consumidora',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setUnidadeConsumidora = value,
              initialValue: _congreg?.unidadeConsumidora ?? null,
            ),
            SizedBox(height: 16),
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
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setCep = value,
              initialValue: _congreg?.cep ?? null,
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
                labelText: 'Complemento',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setComplemento = value,
              initialValue: _congreg?.complemento ?? null,
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
                labelText: 'Bairro',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setBairro = value,
              initialValue: _congreg?.bairro ?? null,
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
                labelText: 'Cidade',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setCidade = value,
              initialValue: _congreg?.cidade ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Estado',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                value: _congreg?.uf,
                hint: Text('UF'),
                onChanged: (value) => setState(() => _congreg.uf = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._dropDownUf,
              ),
            ),
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.name,
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
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setNumero = value,
              initialValue: _congreg?.numero ?? null,
            ),
            SizedBox(height: 16),
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
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'E-mail',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) =>
                  value.length > 0 ? Validator.emailValidator(value) : null,
              onSaved: (value) => _congreg.setEmail = value,
              initialValue: _congreg?.email ?? null,
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
                labelText: 'Telefone Fixo',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setFixo = value,
              initialValue: _congreg?.fixo ?? null,
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
                labelText: 'Celular',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                TelefoneInputFormatter(),
              ],
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _congreg.setCelular = value,
              initialValue: _congreg?.celular ?? null,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Outros',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            SizedBox(height: 16),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'É a sede do campo?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _congreg.isSedeCampo = value),
                value: _congreg?.isSedeCampo ?? false,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'É sede de Setor?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _congreg.isSedeSetor = value),
                value: _congreg?.isSedeSetor ?? false,
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'É sede de Área?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _congreg.isSedeArea = value),
                value: _congreg?.isSedeArea ?? false,
              ),
            ),

            _congreg.id != null 
            ? SizedBox(height: 8)
            : SizedBox(),

            _congreg?.id != null
            ? ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                _congreg?.isActive != null 
                ? _congreg?.isActive == true
                  ? 'Desativar'
                  : 'Ativar'
                : 'Ativar',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _congreg.isActive = value),
                value: _congreg?.isActive ?? false,
              ),
            )
            : SizedBox(),


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
