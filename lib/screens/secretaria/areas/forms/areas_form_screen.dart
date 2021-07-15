import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../helpers/validator.dart';
import '../../../../models/models.dart';
import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';
import '../../../../widgets/widgets.dart';

class AreaForm extends StatefulWidget {
  AreaForm();

  _AreaFormState createState() => _AreaFormState();
}

class _AreaFormState extends State<AreaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController pageController = PageController();
  final int page = 9;

  AreasModel area = new AreasModel();

  void _handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(page);

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AreasRepository>(
      builder: (_, state, __) {
        if (state.area != null) {
         area = state.area;
        }

        Widget _buttonSave() => SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 46,
              child: ElevatedButton(
                onPressed: !state.isLoading
                    ? () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (area?.id == null) {
                            context.read<AreasRepository>().addarea(
                                  area: area,
                                  onFail: (e) {
                                    print(e);
                                    _snackBar(
                                      context: context,
                                      msg:
                                          'Não foi possivel adicionar a área: $e',
                                      isSuccess: false,
                                    );
                                  },
                                  onSuccess: (uid) {
                                    _handlerForm(context);
                                    _snackBar(
                                        context: context,
                                        msg:
                                            'Nova área adicionada com successo!');
                                  },
                                );
                          } else {
                            context.read<AreasRepository>().updateArea(
                                  area: area,
                                  onFail: (e) => _snackBar(
                                    context: context,
                                    msg:
                                        'Não foi possivel atualizar a área: $e',
                                    isSuccess: false,
                                  ),
                                  onSuccess: (uid) {
                                    _handlerForm(context);
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
                    ? Text(area?.id == null ? 'Adicionar' : 'Atualizar')
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
          page: 9,
          title: area?.nome ?? 'Adicionar Área',
          form: [
            SizedBox(height: 32),
            TextFormField(
              keyboardType: TextInputType.text,
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
              onSaved: (value) => area?.setNome = value,
              initialValue: area?.nome ?? null,
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
                value: area?.sede,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => area.setSede = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listCongreg(context: context),
              ),
            ),
            SizedBox(height: 8),
            ListTile(
              title: Text(
                'Setor',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              enabled: !state.isLoading,
              trailing: DropdownButton(
                underline: Container(height: 0, color: Colors.transparent),
                value: area?.setor,
                hint: Text('Escolha'),
                onChanged: (value) => setState(() => area.setsetor = value),
                style: Theme.of(context).textTheme.bodyText1,
                items: this._listSetor(context: context),
              ),
            ),
            SizedBox(height: 32),
            area?.id != null
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
            area?.id != null ? SizedBox(height: 16) : SizedBox(),
            area?.id != null
                ? ListTile(
                    //tileColor: LightStyle.paleta['PrimariaCinza'],
                    title: Text(
                      area?.isActive != null
                          ? area?.isActive == true
                              ? 'Desativar'
                              : 'Ativar'
                          : 'Ativar',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    enabled: !state.isLoading,
                    trailing: Switch(
                      activeColor: Theme.of(context).primaryColor,
                      onChanged: (bool value) => setState(() => area.isActive = value),
                      value: area?.isActive ?? false,
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
