import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:path_provider/path_provider.dart';

class CertificadoBatismo extends StatefulWidget {
  CertificadoBatismo();
  _CertificadoBatismoState createState() => _CertificadoBatismoState();
}

class _CertificadoBatismoState extends State<CertificadoBatismo> {
  final PageController pageController = PageController();
  final int page = 12;

  UserModel membro = new UserModel();
  List<UserModel> batizados = [];
  List<UserModel> selecionados = [];

  String searchString = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // limpa o controller quando for liberado
    searchController.dispose();
    super.dispose();
  }

  void handlerForm(BuildContext context) =>
      context.read<CustomRouter>().setPage(page);

  TextStyle _titleStyle = GoogleFonts.roboto(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: LightStyle.paleta['Cinza'],
  );

  TextEditingController searchController = TextEditingController();

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

  viewPdf(BuildContext context, String path) =>
      context.read<CustomRouter>().setPage(38, screen: path);

  Future<void> createCertificado(BuildContext context) async {
    final pdf.Document pw = pdf.Document(
      deflate: zlib.encode,
    );

/*
    var bg = PdfImage.file(
      pw.document,
      bytes: (await rootBundle.load('batismo.jpg')).buffer.asUint8List(),
    );
*/
    List<pdf.Widget> pdfDocs = [];
    int count = 0;

    for (UserModel e in selecionados) {
      String pronome = e.genero != null
          ? e.genero == 'Masculino'
              ? 'o'
              : 'a'
          : 'o(a)';
      String mae = '${e.nomeMae ?? ''}';
      String pai = '${e.nomePai ?? ''}';

      String linha1 =
          'Ás fls. ${e?.paginaRegistro ?? '00'} do livro n° ${e?.livroRegistro ?? '000'} de Membros desta igreja foi registrad$pronome,';
      String linha2 = '${e.username},';
      String linha3 =
          '${e?.dataNascimento != null ? "nascid$pronome no dia ${e?.dataNascimento ?? '00'}," : ''}';
      String linha4 =
          '${e?.genero != null ? "do sexo ${e?.genero ?? ''}," : ""}';
      String linha5 = 'filh$pronome de ${mae != '' ? mae : ''}';
      String linha6 = '${mae != '' ? pai != '' ? 'e' : '' : ''}';
      String linha7 = '${pai != '' ? pai : ''}';
      String linha8 = 'que de acordo com os ensinamentos bíblicos,';
      String linha9 =
          'foi batizad$pronome no dia ${e.dataBatismoAguas}, tendo dado prova de sua conduta cristã.';

      pdfDocs.add(
        pdf.Container(
          height: PdfPageFormat.a4.dimension.y * 0.5 - 1,
          margin: count % 2 == 0 ? pdf.EdgeInsets.only(bottom: 2) : null,
          decoration: pdf.BoxDecoration(
            image: pdf.DecorationImage(
              image: pdf.MemoryImage(
                  (await rootBundle.load('assets/batismo.jpg'))
                      .buffer
                      .asUint8List()),
              fit: pdf.BoxFit.cover,
            ),
          ),
          child: pdf.Container(
            padding: pdf.EdgeInsets.only(
              top: 160,
              left: 80,
              right: 80,
            ),
            child: pdf.Column(
              children: [
                pdf.Container(
                  margin: pdf.EdgeInsets.only(bottom: 20),
                  child: pdf.Text(
                    '       $linha1 $linha2 $linha3 $linha4 $linha5 $linha6 $linha7 $linha8 $linha9',
                    textAlign: pdf.TextAlign.justify,
                    style: pdf.TextStyle(
                      //font: myFont, //ttf,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                pdf.Container(
                  child: pdf.Row(
                    mainAxisAlignment: pdf.MainAxisAlignment.end,
                    children: [
                      pdf.Text('Icoaraci, Belém/PA 24 de Setembro de 2018.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      count++;
    }

    pw.addPage(
      pdf.MultiPage(
        margin: pdf.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pdf.Container(
            child: pdf.Column(children: pdfDocs),
          )
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/certificados-de-batismo.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pw.save());

    //viewPdf(context, path);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfScreen(path),
      ),
    );
  }

  emitirDocumento(BuildContext context) {
    List<UserModel> documentosEmitidos = [];
    List<UserModel> documentosNaoEmitidos = [];

    for (UserModel membro in selecionados) {
      //salvando documentos
      context.read<DocumentoRepository>().create(
            doc: DocumentoModel(
                membro: membro.id, tipo: 'Certificado de Batismo'),
            onFail: (e) => documentosNaoEmitidos.add(membro),
            /*_snackBar(
              context: context,
              msg: 'Não foi emitir o documento: $e',
              isSuccess: false,
            ),*/
            onSuccess: (uid) => documentosEmitidos.add(membro),
            /*{
              //_handlerForm(context);
              _snackBar(
                context: context,
                msg: 'Documentos emitidos com sucesso!',
              );
            },*/
          );

      membro.setIsSelected = false;
    }

    if (documentosNaoEmitidos.length > 0) {
      _snackBar(
        context: context,
        msg: 'Alguns documentos não puderam ser emitidos',
        isSuccess: false,
      );
    } else {
      _snackBar(
        context: context,
        msg: 'Todos os documentos foram emitidos com sucesso!',
      );
    }

    //PdfGen(context: context).createCertificado();
    createCertificado(context);

    searchController.clear();
    setState(() {
      searchString = '';
      selecionados = [];
      batizados = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        String _title = context.read<CustomRouter>().getScreen;

        search() async =>
            batizados = await state.getBatismoMembros(searchString);

        List<Widget> _listagem() {
          List<Widget> list = [];
          for (var e in batizados) {
            list.add(
              ListTile(
                key: Key(e.id),
                onTap: () {
                  //_handlerForm(form: e.username, membro: e);
                },
                title: Text(
                  e.username,
                  style: _titleStyle,
                ),
                subtitle: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    e.congregacao != null
                        ? e.congregacao != ''
                            ? Text(
                                'Congregação: ${context.read<CongregRepository>().getCongreg(e.congregacao).nome}',
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox()
                        : SizedBox(),
                    e?.isDizimista == true
                        ? Text(
                            'Dizimista',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox(),
                    e?.tipoMembro != null
                        ? e?.tipoMembro != ''
                            ? Text(
                                e.tipoMembro,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox()
                        : SizedBox(),
                    e.situacaoMembro != null
                        ? e.situacaoMembro != ''
                            ? Text(
                                e.situacaoMembro,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : SizedBox()
                        : SizedBox(),
                    e.createdAt != null
                        ? Text(
                            'criado em: ${formataData(data: e.createdAt)}',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox(),
                    e?.isVerified == false
                        ? Text(
                            'Não verificado',
                            style: Theme.of(context).textTheme.overline,
                          )
                        : SizedBox(),
                    e?.isActive == false
                        ? Text(
                            'situação: Inativa',
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        : SizedBox(),
                  ],
                ),
                leading: CircleAvatar(
                  //radius: radius,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: e.profileImageUrl != null
                      ? e.profileImageUrl != ''
                          ? CachedNetworkImageProvider(e.profileImageUrl)
                          : null
                      : null,
                  child: e.profileImageUrl != null
                      ? e.profileImageUrl != ''
                          ? null
                          : Icon(
                              FeatherIcons.home,
                              color: Theme.of(context).canvasColor,
                            )
                      : Icon(
                          FeatherIcons.home,
                          color: Theme.of(context).canvasColor,
                        ),
                ),
                trailing: Checkbox(
                  value: e.getIsSelected,
                  onChanged: (value) {
                    e.setIsSelected = !e.getIsSelected;
                    setState(() {
                      selecionados.contains(e)
                          ? selecionados.remove(e)
                          : selecionados.add(e);
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            );
          }
          return list;
        }

        return DefaultScreen(
          title: _title,
          backToPage: page,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: TextField(
                keyboardType: TextInputType.datetime,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: 'Informe a data',
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  fillColor: LightStyle.paleta['PrimariaCinza'],
                  icon: Icon(
                    FeatherIcons.search,
                    color: Colors.grey[400],
                  ),
                ),
                //enabled: !state.isLoading,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  DataInputFormatter(),
                ],
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                  search();
                },
              ),
            ),
            SizedBox(height: 16),
            Column(
              children: _listagem(),
            )
          ],
          fab: ElevatedButton(
            onPressed:
                selecionados.length > 0 ? () => emitirDocumento(context) : null,
            child: const Icon(FeatherIcons.printer),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: const EdgeInsets.all(20),
            ),
          ),
        );
      },
    );
  }
}
