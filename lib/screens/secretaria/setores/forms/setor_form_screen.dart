import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/validator.dart';
import '../../../../models/models.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class SetorForm extends StatefulWidget {
  final SetorModel setor;

  SetorForm({
    this.setor,
  });

  _SetorFormState createState() => _SetorFormState();
}

class _SetorFormState extends State<SetorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SetorModel _setor = new SetorModel();
  String _title;
  bool _isAddSetor;

  @override
  void initState() {
    super.initState();
    if (widget.setor != null) {
      _setor = widget.setor;
      _title = 'Atualizar Setor';
      _isAddSetor = false;
    } else {
      _title = 'Adicionar Setor';
      _isAddSetor = true;
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
                    if (_isAddSetor) {
                      context.read<SetorRepository>().addSetor(
                            setor: _setor,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel adicionar o setor: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'Novo setor adicionado com successo!');
                            },
                          );
                    } else {
                      context.read<SetorRepository>().updateSetor(
                            setor: _setor,
                            onFail: (e) => _snackBar(
                              context: context,
                              msg: 'Não foi possivel atualizar o setor: $e',
                              isSuccess: false,
                            ),
                            onSuccess: (uid) {
                              Navigator.of(context).pop();
                              _snackBar(
                                  context: context,
                                  msg: 'Setor atualizado com sucesso!');
                            },
                          );
                    }
                  }
                }
              : () {},
          child: !state.isLoading
              ? Text(_isAddSetor ? 'Adicionar' : 'Atualizar')
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
    return Consumer<SetorRepository>(
      builder: (_, state, __) {
        return DefaultForm(
          formKey: _formKey,
          scaffoldKey: _scaffoldKey,
          title: _setor?.nome ?? _title,
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
                labelText: 'Nome do setor',
                labelStyle: Theme.of(context).textTheme.bodyText1,
                fillColor: LightStyle.paleta['PrimariaCinza'],
              ),
              enabled: !state.isLoading,
              validator: (value) => Validator.rgValidator(value),
              onSaved: (value) => _setor.setNome = value,
              initialValue: _setor?.nome ?? null,
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
                value: _setor?.sede,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => _setor.sede = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listCongreg(context: context),
              ),
            ),
            SizedBox(height: 32),
            _setor.id != null
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
            _setor.id != null ? SizedBox(height: 16) : SizedBox(),
            _setor?.id != null
                ? ListTile(
                    //tileColor: LightStyle.paleta['PrimariaCinza'],
                    title: Text(
                      _setor?.isActive != null
                          ? _setor?.isActive == true
                              ? 'Desativar'
                              : 'Ativar'
                          : 'Ativar',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabled: !state.isLoading,
                    trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) =>
                          setState(() => _setor.isActive = value),
                      value: _setor?.isActive ?? false,
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
