import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/image_helper.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/ministerio/ministerio_repository.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/forms/default_form.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class MinisterioForm extends StatefulWidget {
  MinisterioForm();

  _MinisterioFormState createState() => _MinisterioFormState();
}

class _MinisterioFormState extends State<MinisterioForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();
  int pageBack = 14;

  MinisterioModel ministerio = new MinisterioModel();

  File profileImage;

  void _handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(pageBack);

  @override
  void initState() {
    super.initState();
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
    return Consumer<MinisterioRepository>(
      builder: (_, state, __) {
        if (state.ministerio != null) {
          ministerio = state.ministerio;
        }

        String _screen = context.read<CustomRouter>().getScreen;
        String _form = context.read<CustomRouter>().getForm;

        void _selectImage() async {
          final pickedFile = await ImageHelper.pickImageFromGallery(
            context: context,
            cropStyle: CropStyle.rectangle, //CropStyle.circle,
            title: 'Foto do ministério',
          );
          if (pickedFile != null) {
            setState(() {
              profileImage = pickedFile;
            });
          }
        }

        Widget buttonOption({
          String text,
          Function onOption,
          bool isActive = true,
        }) =>
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: !state.isLoading
                    ? () {
                        onOption();

                        isActive = true;

                        context.read<MinisterioRepository>().updateMinisterio(
                              ministerio: ministerio,
                              image: profileImage ?? null,
                              onFail: (e) => _snackBar(
                                context: context,
                                msg: 'Falha ao atualizar os dados: $e',
                                isSuccess: false,
                              ),
                              onSuccess: (uid) {
                                _handlerForm(context);
                                _snackBar(
                                    context: context, msg: 'Dados atualizados');
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
                child: !state.isLoading
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

        Widget _buttonSave() => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: !state.isLoading
                    ? () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          context.read<MinisterioRepository>().updateMinisterio(
                              ministerio: ministerio,
                              image: profileImage ?? null,
                              onFail: (e) => _snackBar(
                                    context: context,
                                    msg: 'Não foi possivel atualizar: $e',
                                    isSuccess: false,
                                  ),
                              onSuccess: (uid) {
                                _handlerForm(context);
                                _snackBar(
                                    context: context,
                                    msg: 'Registro atualizado!');
                              });
                        }
                      }
                    : () {},
                child: !state.isLoading
                    ? Text('Atualizar')
                    : SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
              ),
            );

        Map<String, List> listasMinisterio = {
          'fiscal': ministerio?.fiscal != null 
          ? ministerio?.fiscal : [],
          'etica': ministerio?.etica != null 
          ? ministerio?.etica : [],
          'pastores': ministerio?.pastores != null 
          ? ministerio?.pastores : [],
          'consagrados': ministerio?.evanConsagrados != null 
          ? ministerio?.evanConsagrados : [],
          'autorizados': ministerio?.evanAutorizados != null 
          ? ministerio?.evanAutorizados : [],
          'locais': ministerio?.evanLocais != null 
          ? ministerio?.evanLocais : [],
          'presbiteros': ministerio?.presbiteros != null 
          ? ministerio?.presbiteros : [],
          'diaconos': ministerio?.diaconos != null 
          ? ministerio?.diaconos : [],
          'auxiliares': ministerio?.auxiliares != null 
          ? ministerio?.auxiliares : [],
          'obreiros': ministerio?.obreiros != null 
          ? ministerio?.obreiros : [],
        };

        List<Widget> _listMembros({
          @required String nome,
          @required List lista, 
          @required Function onSave,
        }) {

          List<UserModel> membros = context.read<MembroRepository>().getListMembros;

          return [
            for (var e in membros)
              lista.contains(e.id)
                  ? SizedBox()
                  : e.isActive
                      ? buttonOption(
                          text: e.username,
                          isActive: false,
                          onOption: () {
                            listasMinisterio[nome].add(e.id);
                            pageBack = 28;
                            //ministerio?.pastores = listasMinisterio[lista];
                            onSave();
                          },
                        )
                      : SizedBox(),
          ];
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

        List<DropdownMenuItem<String>> _listPastores() {
          List<UserModel> list =
              context.read<MinisterioRepository>().listPastores;

          return list.map<DropdownMenuItem<String>>((UserModel pastor) {
            return DropdownMenuItem(
              value: pastor.id,
              child: Text(
                pastor.username,
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

        Map<String, List<Widget>> forms = {
          'Informações básicas': [
            UploadImage(
              onTap: () => _selectImage(),
              isLoading: false,
              image: profileImage,
              imageUrl: ministerio?.profileImageUrl ?? '',
            ),
            SizedBox(height: 48),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Informações Gerais',
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
                labelText: 'Nome do Ministério',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) => Validator.nameValidator(value),
              onSaved: (value) => ministerio.nome = value,
              initialValue: ministerio?.nome ?? null,
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text(
                'Sede',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: ministerio?.sede,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => ministerio.sede = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: _listCongreg(),
              ),
            ),
            SizedBox(height: 32),
            state.ministerio.pastores != null
                ? state.ministerio.pastores.isNotEmpty
                    ? ListTile(
                        title: Text(
                          'Presidente',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        enabled: !state.isLoading,
                        subtitle: DropdownButton(
                          underline:
                              Container(height: 0, color: Colors.transparent),
                          value: ministerio?.presidente,
                          hint: Text('Escolha'),
                          onChanged: (value) =>
                              setState(() => ministerio.presidente = value),
                          style: Theme.of(context).textTheme.bodyText1,
                          items: _listPastores(),
                        ),
                      )
                    : Container()
                : Container(),
            state.ministerio.pastores != null
                ? state.ministerio.pastores.isNotEmpty
                    ? SizedBox(height: 32)
                    : Container()
                : Container(),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Sigla',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              onSaved: (value) => ministerio.sigla = value,
              initialValue: ministerio?.sigla ?? null,
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
                labelText: 'CNPJ',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CnpjInputFormatter(),
              ],
              enabled: !state.isLoading,
              onSaved: (value) => ministerio.cnpj = value,
              initialValue: ministerio?.cnpj ?? null,
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
              onSaved: (value) => ministerio.fundacao = value,
              initialValue: ministerio?.fundacao ?? null,
            ),
            SizedBox(height: 32),
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
              onSaved: (value) => ministerio.telefoneFixo = value,
              initialValue: ministerio?.telefoneFixo ?? null,
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
              onSaved: (value) => ministerio.telefoneCelular = value,
              initialValue: ministerio?.telefoneCelular ?? null,
            ),
            SizedBox(height: 32),
            _buttonSave(),
          ],
          'Adicionar Fiscal': _listMembros(
            nome: 'fiscal',
            lista: ministerio?.fiscal ?? [],
            onSave: () => ministerio?.fiscal = listasMinisterio['fiscal'],
          ),
          'Adicionar Conselheiro': _listMembros(
            nome: 'etica',
            lista: ministerio?.etica ?? [],
            onSave: () => ministerio?.etica = listasMinisterio['etica'],
          ),
          'Adicionar departamento': [],
          'Adicionar Pastor': _listMembros(
            nome:'pastores',
            lista: ministerio?.pastores ?? [],
            onSave: () => ministerio?.pastores = listasMinisterio['pastores'],
          ),
          'Adicionar \nEvangelista Consagrado': _listMembros(
            nome: 'consagrado',
            lista: ministerio?.evanConsagrados ?? [],
            onSave: () => ministerio?.evanConsagrados = listasMinisterio['consagrado'],
          ),
          'Adicionar \nEvangelista Autorizado': _listMembros(
            nome: 'autorizado',
            lista: ministerio?.evanAutorizados ?? [],
            onSave: () => ministerio?.evanAutorizados = listasMinisterio['autorizado'],
          ),
          'Adicionar \nEvangelista Local': _listMembros(
            nome: 'local',
            lista: ministerio?.evanLocais?? [],
            onSave: () => ministerio?.evanLocais = listasMinisterio['local'],
          ),
          'Adicionar Presbítero': _listMembros(
            nome: 'presbitero',
            lista: ministerio?.presbiteros ?? [],
            onSave: () => ministerio?.presbiteros = listasMinisterio['presbitero'],
          ),
          'Adicionar Diácono': _listMembros(
            nome: 'diacono',
            lista: ministerio?.diaconos ?? [],
            onSave: () => ministerio?.diaconos = listasMinisterio['diacono'],
          ),
          'Adicionar Auxiliar': _listMembros(
            nome: 'auxiliar',
            lista: ministerio?.auxiliares ?? [],
            onSave: () => ministerio?.auxiliares = listasMinisterio['auxiliar'],
          ),
          'Adicionar Obreiro': _listMembros(
            nome: 'obreiro',
            lista: ministerio?.obreiros ?? [],
            onSave: () => ministerio?.obreiros = listasMinisterio['obreiro'],
          ),
        };

        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          page: pageBack,
          screen: _screen,
          title: _form,
          // 'Editar Informações',
          form: forms[_form],
        );
      },
    );
  }
}
