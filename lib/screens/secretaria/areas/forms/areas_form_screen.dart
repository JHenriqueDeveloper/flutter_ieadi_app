import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/validator.dart';
import '../../../../models/models.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class AreaForm extends StatefulWidget {
  final AreasModel area;

  AreaForm({
    this.area,
  });

  _AreaFormState createState() => _AreaFormState();
}

class _AreaFormState extends State<AreaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AreasModel _area = new AreasModel();
  String _title;
  bool _isAddArea;

  @override
  void initState() {
    super.initState();
    if (widget.area != null) {
      _area = widget.area;
      _title = 'Atualizar Área';
      _isAddArea = false;
    } else {
      _title = 'Adicionar Área';
      _isAddArea = true;
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

  List<DropdownMenuItem<String>> _listSetor({
    BuildContext context,
  }) {
    List<SetorModel> list = context.read<SetorRepository>().getListSetor;

    return list.map<DropdownMenuItem<String>>((SetorModel setor) {
      return DropdownMenuItem(
        value: setor.id,
        child: Text(
              setor.nome,
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
                    if (_isAddArea) {
                      context.read<AreasRepository>().addarea(
                            area: _area,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel adicionar a área: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg:
                                      'Nova área adicionada com successo!');
                            },
                          );
                    } else {
                      context.read<AreasRepository>().updateArea(
                            area: _area,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg:
                                  'Não foi possivel atualizar a área: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'Área atualizada com sucesso!');
                            },
                          );
                    }
                  }
                }
              : () {},
          child: !state.isLoading
              ? Text(_isAddArea ? 'Adicionar' : 'Atualizar')
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
    return Consumer<AreasRepository>(
      builder: (_, state, __) {
        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: _area?.nome ?? _title,
          form: [
            SizedBox(height: 48),
            TextFormField(
              keyboardType: TextInputType.name,
              autocorrect: false,
              maxLength: 50,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                labelText: 'Nome da área',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _area.setNome = value,
              initialValue: _area?.nome ?? null,
            ),
            SizedBox(height: 16),

            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Sede',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _area?.sede,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => _area.sede = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listCongreg(context: context),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                'Setor',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: _area?.setor,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => _area.setor = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listSetor(context: context),
              ),
            ),
            SizedBox(height: 32),
            _area.id != null 
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

            _area.id != null 
            ? SizedBox(height: 16)
            : SizedBox(),

            _area?.id != null
            ? ListTile(
              //tileColor: LightStyle.paleta['PrimariaCinza'],
              title: Text(
                _area?.isActive != null 
                ? _area?.isActive == true
                  ? 'Desativar'
                  : 'Ativar'
                : 'Ativar',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: Switch(
                activeColor: Theme.of(context).primaryColor,
                onChanged: (bool value) =>
                    setState(() => _area.isActive = value),
                value: _area?.isActive ?? false,
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
