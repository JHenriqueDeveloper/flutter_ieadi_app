import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ieadi_app/config/config.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
      return auth.user != null 
      ? MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => CongregRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => AreasRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => SetorRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => MembroRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => MinisterioRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => SolicitacoesRepository(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => DocumentoRepository(),
            lazy: false,
          ),
        ],
        child: Provider(
          create: (_) => CustomRouter(pageController),
          child: PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              //HOME
              NavScreen(), //0
              ServicosScreen(), //1
              PessoaisScreen(), //2
              EnderecoScreen(), //3
              ContatosScreen(), //4
              CristaoScreen(), //5
              CurriculoScreen(), //6
              ContaScreen(), //7
              //secretaria
              DashboardScreen(), //8
              AreasScreen(), //9
              CertificadosScreen(), //10
              CongregacoesScreen(), //11
              DocumentosScreen(), //12
              MembrosScreen(), //13
              MinisterioScreen(), //14
              SettingsScreen(), //15
              SetorScreen(), //16
              SolicitacoesScreen(), //17
              VerificacoesScreen(), //18

              //formularios da home
              ContatosFormScreen(), //19
              CristaoFormScreen(), //20
              CurriculoFormScreen(), //21
              EnderecoFormScreen(), //22
              PessoaisFormScreen(), //23

              //formularios da secretaria
              AreaForm(), //24
              CongregForm(), //25
              MembroForm(), //26
              MinisterioForm(), //27
              MinisterioOptionsScreen(), //28
              SetorForm(), //29
              //Serviços
              VerificacoesForm(), //30

              //documentos
              CartaMudanca(), //31
              CartaRecomendacao(), //32
              CartaoMembro(), //33
              CertificadoApresentacao(), //34
              CertificadoBatismo(), //35
              CredencialMinisterio(), //36
              DeclaracaoMembro(), //37

              //outras
              //PdfScreen(), //38
            ],
          ),
        ),
      )
      : Center(
        child: CircularProgressIndicator(),
      );
    },
    );
  }
}
