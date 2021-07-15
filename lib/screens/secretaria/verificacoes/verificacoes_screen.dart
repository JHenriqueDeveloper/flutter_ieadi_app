import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/style/light/light_style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../widgets/widgets.dart';

class VerificacoesScreen extends StatelessWidget {
  final PageController pageController = PageController();
  final int page = 30;

  @override
  Widget build(BuildContext context) {
    return Consumer<SolicitacoesRepository>(
      builder: (_, state, __) {
        void _handlerForm({
          String form,
          SolicitacoesModel solicitacao,
        }) {
          state.solicitacao = solicitacao;
          UserModel membro = context
              .read<MembroRepository>()
              .getmembro(solicitacao.solicitante);

          context.read<MembroRepository>().membro = membro;
          return context.read<CustomRouter>().setPage(26, form: form, back: 18);
        }

        List<Widget> _listagem() {
          List<Widget> list = [];
          for (var e in state.getListSolicitacoes) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: e.isActive ? () {
                  _handlerForm(
                    form: e.tipo,
                    solicitacao: e,
                  );
                } : null,
                title: Text(
                  e.tipo,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    height: 1.5,
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                    color: LightStyle.paleta['Cinza'],
                  ),
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status: ${e.status}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      'solicitado em: ${formataData(data: e.createdAt)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                leading: Icon(
                  FeatherIcons.circle,
                  color: e?.isActive == true ? Colors.red : Colors.grey[400],
                ),
                trailing: Icon(
                  FeatherIcons.chevronRight,
                  color: Colors.grey[400],
                ),
              ),
            );
          }
          return list;
        }

        return DefaultScreen(
          title: 'Verificações',
          backToPage: 8,
          //padding: const EdgeInsets.only(bottom: 32),
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 48),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: _listagem(),
              ),
            ),
          ],
        );
      },
    );
  }
}
