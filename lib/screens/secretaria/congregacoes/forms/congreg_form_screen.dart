import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/image_helper.dart';
import 'package:flutter_ieadi_app/models/congreg/congreg_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/util.dart';
import '../../../../helpers/validator.dart';
import '../../../../models/models.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class CongregForm extends StatefulWidget {
  CongregForm();
  _CongregFormState createState() => _CongregFormState();
}

class _CongregFormState extends State<CongregForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();
  final int page = 11;

  CongregModel congreg = new CongregModel();

  void _handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(page);

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<CongregRepository>(
      builder: (_, state, __) {
        if (state.congreg != null) {
          congreg = state.congreg;
        }

        List<DropdownMenuItem<String>> _dropDownUf() {
          List<String> list = uf_list;
          return list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
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
            );
          }).toList();
        }

        List<DropdownMenuItem<String>> _listAreas() {
          List<AreasModel> list = context.read<AreasRepository>().getListAreas;
          return list.map<DropdownMenuItem<String>>((AreasModel area) {
            return DropdownMenuItem(
              value: area.id,
              child: Text(
                area.nome,
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

        Widget _buttonSave() => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: !state.isLoading
                    ? () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (congreg?.id == null) {
                            context.read<CongregRepository>().addCongreg(
                                  congreg: congreg,
                                  image: profileImage ?? null,
                                  onFail: (e) => _snackBar(
                                    context: context,
                                    msg:
                                        'Não foi possivel adicionar congregação: $e',
                                    isSuccess: false,
                                  ),
                                  onSuccess: (uid) {
                                    _handlerForm(context);
                                    _snackBar(
                                      context: context,
                                      msg:
                                          'Nova congregação adicionada com successo!',
                                    );
                                  },
                                );
                          } else {
                            context.read<CongregRepository>().updateCongreg(
                                  congreg: congreg,
                                  image: profileImage ?? null,
                                  onFail: (e) => _snackBar(
                                    context: context,
                                    msg:
                                        'Não foi possivel atualizar a congregação: $e',
                                    isSuccess: false,
                                  ),
                                  onSuccess: (uid) {
                                    _handlerForm(context);
                                    _snackBar(
                                        context: context,
                                        msg:
                                            'Congregação atualizada com sucesso!');
                                  },
                                );
                          }
                        }
                      }
                    : () {},
                child: !state.isLoading
                    ? Text(congreg?.id == null ? 'Adicionar' : 'Atualizar')
                    : SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
              ),
            );

        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: congreg?.nome ?? 'Adicionar Congregação',
          page: page,
          form: [
            UploadImage(
              onTap: () => _selectImage(context),
              isLoading: false,
              image: profileImage,
              imageUrl: congreg?.profileImageUrl ?? '',
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
              onSaved: (value) => congreg.setNome = value,
              initialValue: congreg?.nome ?? null,
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
              onSaved: (value) => congreg.setDataFundacao = value,
              initialValue: congreg?.dataFundacao ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Área',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: congreg?.idArea,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => congreg.setIdArea = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _listAreas(),
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
                labelText: 'Unidade Consumidora',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              //validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => congreg.setUnidadeConsumidora = value,
              initialValue: congreg?.unidadeConsumidora ?? null,
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
              onSaved: (value) => congreg.setCep = value,
              initialValue: congreg?.cep ?? null,
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
                labelText: 'Logradouro',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => congreg.setLogradouro = value,
              initialValue: congreg?.logradouro ?? null,
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
              onSaved: (value) => congreg.setComplemento = value,
              initialValue: congreg?.complemento ?? null,
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
              onSaved: (value) => congreg.setBairro = value,
              initialValue: congreg?.bairro ?? null,
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
              onSaved: (value) => congreg.setCidade = value,
              initialValue: congreg?.cidade ?? null,
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
                underline: Container(height: 0, color: Colors.transparent),
                value: congreg?.uf,
                hint: Text('UF'),
                onChanged: (value) => setState(() => congreg.setUf = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _dropDownUf(),
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
              onSaved: (value) => congreg.setNumero = value,
              initialValue: congreg?.numero ?? null,
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
              onSaved: (value) => congreg.setEmail = value,
              initialValue: congreg?.email ?? null,
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
              onSaved: (value) => congreg.setFixo = value,
              initialValue: congreg?.fixo ?? null,
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
              onSaved: (value) => congreg.setCelular = value,
              initialValue: congreg?.celular ?? null,
            ),
            SizedBox(height: 16),
            congreg?.id != null
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Outros',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(height: congreg?.id != null ? 16 : 0),
            congreg?.id != null
                ? ListTile(
                    //tileColor: LightStyle.paleta['PrimariaCinza'],
                    title: Text(
                      congreg?.isActive != null
                          ? congreg?.isActive == true
                              ? 'Desativar'
                              : 'Ativar'
                          : 'Ativar',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabled: !state.isLoading,
                    trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) =>
                          setState(() => congreg.isActive = value),
                      value: congreg?.isActive ?? false,
                    ),
                  )
                : SizedBox(),
            SizedBox(height: 32),
            _buttonSave(),
          ],
        );
      },
    );
  }
}
