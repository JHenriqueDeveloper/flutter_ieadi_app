import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/home/contatos/forms/contatos_form_screen.dart';
import 'package:flutter_ieadi_app/screens/home/cristao/forms/cristao_form_screen.dart';
import 'package:flutter_ieadi_app/screens/home/curriculo/forms/curriculo_form_screen.dart';
import 'package:flutter_ieadi_app/screens/home/endereco/forms/endereco_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/areas/forms/areas_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/congregacoes/forms/congreg_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/documentos/forms/documentos_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/membros/forms/membros_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/ministerio/forms/ministerio_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/ministerio/ministerio_options_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/setores/forms/setor_form_screen.dart';
import 'package:flutter_ieadi_app/screens/secretaria/verificacoes/form/verificacoes_form.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';

class BaseScreen extends StatelessWidget {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
              CongregForm(),//25
              MembroForm(),//26
              MinisterioForm(),//27
              MinisterioOptionsScreen(),//28
              SetorForm(),//29
              //Serviços
              VerificacoesForm(), //30
              DocumentosForm(), //31
            ],
          ),
        ));
  }
}
