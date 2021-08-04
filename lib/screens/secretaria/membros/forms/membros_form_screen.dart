import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
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


import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

class MembroForm extends StatefulWidget {
  MembroForm();
  MembroFormState createState() => MembroFormState();
}

class MembroFormState extends State<MembroForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();
  int page = 13;

  UserModel membro = new UserModel();

  void _handlerForm(BuildContext context) {
    if (context.read<CustomRouter>().getBackPage > 0) {
      int back = context.read<CustomRouter>().getBackPage;
      context.read<CustomRouter>().setPage(back);
      context.read<CustomRouter>().setBackPage = 0;
    } else {
      context.read<CustomRouter>().setPage(page);
    }
  }

  @override
  void initState() {
    super.initState();
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

  
  Future<pdf.Widget> fichaDeMembroPdf(UserModel e) async {
    return pdf.Container(
      height: PdfPageFormat.a4.dimension.y - 3,
      width: PdfPageFormat.a4.dimension.x - 3,
      child: pdf.Container(
        child: pdf.Column(
          children: [
            pdf.Row(
              children: [
                
              ]
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        if (state.membro != null) {
          membro = state.membro;
        }

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

        List<DropdownMenuItem<String>> _listCongreg() {
          List<CongregModel> list =
              context.read<CongregRepository>().getListCongregs;
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

        Widget _buttonSave() => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: !state.isLoading
                    ? () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();

                          if (membro?.isVerificacaoSolicitada == true) {
                              membro.isVerified = true;
                              membro.isVerificacaoSolicitada = false;

                              SolicitacoesModel solicitacao = context
                                  .read<SolicitacoesRepository>()
                                  .solicitacao;

                              solicitacao.status = 'Resolvida';
                              solicitacao.isActive = false;

                              context
                                  .read<SolicitacoesRepository>()
                                  .updateSolicitacao(
                                      solicitacao: solicitacao,
                                      onFail: (e) => _snackBar(
                                            context: context,
                                            msg: membro?.isVerificacaoSolicitada ==
                                                    true
                                                ? 'Não foi possivel verificar o membro: $e'
                                                : 'Não foi possivel atualizar o membro: $e',
                                            isSuccess: false,
                                          ),
                                      onSuccess: (uid) {
                                        context
                                            .read<MembroRepository>()
                                            .updateMembro(
                                              membro: membro,
                                              image: profileImage ?? null,
                                              onFail: (e) => _snackBar(
                                                context: context,
                                                msg:
                                                    'Não foi possivel verificar o membro: $e',
                                                isSuccess: false,
                                              ),
                                              onSuccess: (uid) {
                                                _handlerForm(context);
                                                _snackBar(
                                                  context: context,
                                                  msg:
                                                      'membro verificado com sucesso!',
                                                );
                                              },
                                            );
                                      });
                            } else {
                              context.read<MembroRepository>().updateMembro(
                                    membro: membro,
                                    image: profileImage ?? null,
                                    onFail: (e) => _snackBar(
                                      context: context,
                                      msg:
                                          'Não foi possivel atualizar o membro: $e',
                                      isSuccess: false,
                                    ),
                                    onSuccess: (uid) {
                                      _handlerForm(context);
                                      _snackBar(
                                          context: context,
                                          msg:
                                              'membro atualizado com sucesso!');
                                    },
                                  );
                            }
                        }
                      }
                    : () {},
                child: !state.isLoading
                    ? membro?.isVerified == false
                        ? Text(membro?.isVerificacaoSolicitada == true
                            ? 'Verificar conta'
                            : 'Atualizar')
                        : Text('Atualizar')
                    : SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
              ),
            );

        String membroNome =
            membro?.username != '' ? firstName(membro?.username) : '';

        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: membroNome ?? 'Verificar Membro',
          page: context.read<CustomRouter>().getBackPage > 0
              ? context.read<CustomRouter>().getBackPage
              : page,
          actions: [
            IconButton(
              icon: Icon(FeatherIcons.printer), 
              color: LightStyle.paleta['Background'],
              onPressed: (){},
            )
          ],
          form: [
            UploadImage(
              onTap: () => _selectImage(context),
              isLoading: false,
              image: profileImage,
              imageUrl: membro?.profileImageUrl ?? '',
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
              onSaved: (value) => membro.username = value,
              initialValue: membro?.username ?? null,
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
                value: membro?.genero == '' ? null : membro.genero,
                hint: Text('Não Informado'),
                onChanged: (value) => setState(() => membro.genero = value),
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
              onSaved: (value) => membro.cpf = value,
              initialValue: membro?.cpf ?? null,
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
              onSaved: (value) => membro.rg = value,
              initialValue: membro?.rg ?? null,
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
              onSaved: (value) => membro.naturalidade = value,
              initialValue: membro?.naturalidade ?? null,
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
              onSaved: (value) => membro.dataNascimento = value,
              initialValue: membro?.dataNascimento ?? null,
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
              onSaved: (value) => membro.nomePai = value,
              initialValue: membro?.nomePai ?? null,
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
              onSaved: (value) => membro.nomeMae = value,
              initialValue: membro?.nomeMae ?? null,
            ),
            ListTile(
              title: Text(
                'Estado civil',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: membro?.estadoCivil == '' ? null : membro.estadoCivil,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => membro.estadoCivil = value),
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
                value:
                    membro?.tipoSanguineo == '' ? null : membro?.tipoSanguineo,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => membro.tipoSanguineo = value),
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
              onSaved: (value) => membro.tituloEleitor = value,
              initialValue: membro?.tituloEleitor ?? null,
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
              onSaved: (value) => membro.zonaEleitor = value,
              initialValue: membro?.zonaEleitor ?? null,
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
              onSaved: (value) => membro.secaoEleitor = value,
              initialValue: membro?.secaoEleitor ?? null,
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
                    setState(() => membro.isPortadorNecessidade = value),
                value: membro?.isPortadorNecessidade ?? false,
              ),
            ),
            membro?.isPortadorNecessidade == true
                ? SizedBox(height: 16)
                : SizedBox(),
            membro?.isPortadorNecessidade == true
                ? ListTile(
                    title: Text(
                      'Tipo de \nnecessidade especial',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabled: !state.isLoading,
                    trailing: DropdownButton(
                      underline:
                          Container(height: 0, color: Colors.transparent),
                      value: membro?.tipoNecessidade,
                      hint: Text('Não Informado'),
                      onChanged: (value) =>
                          setState(() => membro.tipoNecessidade = value),
                      style: Theme.of(context).textTheme.bodyText1,
                      items: _dropList(necessidades_list),
                    ),
                  )
                : SizedBox(),
            membro?.isPortadorNecessidade == true
                ? SizedBox(height: 32)
                : SizedBox(),
            membro?.isPortadorNecessidade == true
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
                    onSaved: (value) => membro.descricaoNecessidade = value,
                    initialValue: membro?.descricaoNecessidade ?? null,
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
              onSaved: (value) => membro.cep = value,
              initialValue: membro?.cep ?? null,
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
                value: membro?.uf == '' ? null : membro.uf,
                hint: Text('UF'),
                onChanged: (value) => setState(() => membro.uf = value),
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
              onSaved: (value) => membro.cidade = value,
              initialValue: membro?.cidade ?? null,
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
              onSaved: (value) => membro.bairro = value,
              initialValue: membro?.bairro ?? null,
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
              onSaved: (value) => membro.logradouro = value,
              initialValue: membro?.logradouro ?? null,
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
              onSaved: (value) => membro.complemento = value,
              initialValue: membro?.complemento ?? null,
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
              onSaved: (value) => membro.numero = value,
              initialValue: membro?.numero ?? null,
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
              onSaved: (value) => membro.numeroFixo = value,
              initialValue: membro?.numeroFixo ?? null,
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
              onSaved: (value) => membro.numeroCelular = value,
              initialValue: membro?.numeroCelular ?? null,
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
                    setState(() => membro.isDizimista = value),
                value: membro?.isDizimista ?? false,
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
                value: membro?.congregacao != null
                    ? membro?.congregacao != ''
                        ? membro?.congregacao
                        : null
                    : null,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => membro.congregacao = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _listCongreg(),
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
                value: membro?.tipoMembro == '' ? null : membro.tipoMembro,
                hint: Text('Não Informado'),
                onChanged: (value) => setState(() => membro.tipoMembro = value),
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
                value:
                    membro?.situacaoMembro == '' ? null : membro.situacaoMembro,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => membro.situacaoMembro = value),
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
                value: membro?.procedenciaMembro == ''
                    ? null
                    : membro.procedenciaMembro,
                hint: Text('Não Informado'),
                onChanged: (value) =>
                    setState(() => membro.procedenciaMembro = value),
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
              onSaved: (value) => membro.origemMembro = value,
              initialValue: membro?.origemMembro ?? null,
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
              onSaved: (value) => membro.dataMudanca = value,
              initialValue: membro?.dataMudanca ?? null,
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
              onSaved: (value) => membro.localConversao = value,
              initialValue: membro?.localConversao ?? null,
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
              onSaved: (value) => membro.dataConversao = value,
              initialValue: membro?.dataConversao ?? null,
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
              onSaved: (value) => membro.localBatismoAguas = value,
              initialValue: membro?.localBatismoAguas ?? null,
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
              onSaved: (value) => membro.dataBatismoAguas = value,
              initialValue: membro?.dataBatismoAguas ?? null,
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
              onSaved: (value) => membro.localBatismoEspiritoSanto = value,
              initialValue: membro?.localBatismoEspiritoSanto ?? null,
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
              onSaved: (value) => membro.dataBatismoEspiritoSanto = value,
              initialValue: membro?.dataBatismoEspiritoSanto ?? null,
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
              onSaved: (value) => membro?.bio = value,
              initialValue: membro?.bio ?? null,
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Currículo',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.left,
                ),
              ],
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
              labelText: 'Profissão',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !state.isLoading,
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => membro?.profissao = value,
            initialValue:
                membro?.profissao != null ? membro?.profissao : null,
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
              labelText: 'Pretensão Salárial',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !state.isLoading,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              RealInputFormatter(),
            ],
            validator: (value) => Validator.rgValidator(value),
            onSaved: (value) => membro?.pretensaoSalarial = value,
            initialValue: membro?.pretensaoSalarial != null
                ? membro?.pretensaoSalarial
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 1000,
            maxLines: 15,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText: 'Objetivos profissionais',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !state.isLoading,
            validator: (descri) => Validator.descricaoValidator(descri),
            onSaved: (descri) => membro?.objetivos = descri,
            initialValue:
                membro?.objetivos != null ? membro?.objetivos : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            maxLength: 2000,
            maxLines: 15,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              labelText:
                  'Perfil profissional.',
              labelStyle: Theme.of(context).textTheme.bodyText1,
              fillColor: LightStyle.paleta['PrimariaCinza'],
            ),
            enabled: !state.isLoading,
            validator: (descri) => Validator.descricaoValidator(descri),
            onSaved: (descri) => membro?.bioProfissional = descri,
            initialValue:membro?.bioProfissional != null
                ? membro?.bioProfissional
                : null,
          ),
          SizedBox(height: 16),

            _buttonSave(),
          ],
        );
      },
    );
  }
}
