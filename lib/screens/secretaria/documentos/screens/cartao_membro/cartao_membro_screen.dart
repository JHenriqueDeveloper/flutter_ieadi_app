import 'package:brasil_fields/brasil_fields.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/helpers/matricula_helper.dart';
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

class CartaoMembro extends StatefulWidget {
  CartaoMembro();
  _CartaoMembroState createState() => _CartaoMembroState();
}

class _CartaoMembroState extends State<CartaoMembro> {
  final PageController pageController = PageController();
  final int page = 12;

  UserModel membro = new UserModel();
  List<UserModel> listagem = [];
  List<UserModel> selecionados = [];

  String searchString = '';
  String idDocumento = '';

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

  Future<void> criarDocumento(BuildContext context) async {
    final pdf.Document pw = pdf.Document(
      deflate: zlib.encode,
    );
    List<pdf.Widget> pdfDocs = [];

    for (UserModel e in selecionados) {
      await context.read<DocumentoRepository>().create(
            doc: DocumentoModel(
              membro: membro.id,
              tipo: 'Cartão de Membro',
            ),
            onFail: (e) {}, //documentosNaoEmitidos.add(membro),
            onSuccess: (uid) {
              setState(() {
                idDocumento = uid;
              });
            },
          );


      if (e.matricula == null || e.matricula == '') {
        e.matricula = MatriculaHelper(userId: e.id).getMatricula;
        e.isMemberCard = true;
        await context
            .read<MembroRepository>()
            .updateMembro(membro: e, onFail: (e) {}, onSuccess: (uid) {});
      }

      //frente
      pdfDocs.add(
        pdf.Container(
          width: 227,
          height: 142,
          decoration: pdf.BoxDecoration(
            color: PdfColor.fromHex('#4478EE'),
            borderRadius: pdf.BorderRadius.all(
              pdf.Radius.circular(20),
            ),
            gradient: pdf.LinearGradient(
                begin: pdf.Alignment.bottomLeft,
                end: pdf.Alignment.topRight,
                colors: [
                  PdfColor.fromHex('#4478EE'),
                  PdfColor.fromHex('1A1C28'),
                ]),
          ),
          padding: pdf.EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: pdf.Container(
            decoration: pdf.BoxDecoration(
              image: pdf.DecorationImage(
                image: pdf.MemoryImage(
                    (await rootBundle.load('assets/logo02.png'))
                        .buffer
                        .asUint8List()),
                fit: pdf.BoxFit.scaleDown,
              ),
            ),
            child: pdf.Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                pdf.Row(
                  children: [
                    pdf.Text(
                      'Membro',
                      style: pdf.TextStyle(
                        fontSize: 10,
                        letterSpacing: 0,
                        color: PdfColor.fromHex('f6f6f6'),
                        height: 1.5,
                      ),
                    ),
                    pdf.Spacer(),
                    pdf.Container(
                      width: 48,
                      height: 48,
                      decoration: pdf.BoxDecoration(
                        image: pdf.DecorationImage(
                          image: pdf.MemoryImage(
                              (await rootBundle.load('assets/logo01.png'))
                                  .buffer
                                  .asUint8List()),
                        ),
                      ),
                    ),
                  ],
                ),
                pdf.Spacer(),
                pdf.Container(
                  child: pdf.Column(
                    crossAxisAlignment: pdf.CrossAxisAlignment.start,
                    mainAxisSize: pdf.MainAxisSize.max,
                    children: [
                      pdf.Row(
                        children: [
                          pdf.Text(
                            e.username,
                            style: pdf.TextStyle(
                              fontSize: 10,
                              letterSpacing: 0,
                              color: PdfColor.fromHex('f6f6f6'),
                              height: 1.5,
                            ),
                            //textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      pdf.Text(
                        e.matricula,
                        //'6B55668R-93',
                        style: pdf.TextStyle(
                          fontSize: 10,
                          letterSpacing: 0,
                          color: PdfColor.fromHex('f6f6f6'),
                          height: 1.5,
                        ),
                        //textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    pw.addPage(
      pdf.MultiPage(
        margin: pdf.EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pdf.Center(
            child: pdf.Container(
              child: pdf.Wrap(
                spacing: 1.0,
                runSpacing: 1.0,
                children: pdfDocs,
              ),

              //pdf.Column(children: pdfDocs),
            ),
          ),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/cartao-de-membro.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pw.save());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfScreen(path),
      ),
    );
  }

  emitirDocumento(BuildContext context) {
    //List<UserModel> documentosEmitidos = [];
    List<UserModel> documentosNaoEmitidos = [];

    for (UserModel membro in selecionados) {
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
    criarDocumento(context);

    searchController.clear();
    setState(() {
      searchString = '';
      selecionados = [];
      listagem = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MembroRepository>(
      builder: (_, state, __) {
        String _title = context.read<CustomRouter>().getScreen;

        search() async => listagem = await state.searchTags(searchString);

        List<Widget> _listagem() {
          List<Widget> list = [];
          for (var e in listagem) {
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
                keyboardType: TextInputType.text,
                autocorrect: false,
                maxLength: 50,
                maxLines: 1,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: InputDecoration(
                  hintText: 'Buscar',
                  hintStyle: Theme.of(context).textTheme.bodyText1,
                  fillColor: LightStyle.paleta['PrimariaCinza'],
                  icon: Icon(
                    FeatherIcons.search,
                    color: Colors.grey[400],
                  ),
                ),
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
