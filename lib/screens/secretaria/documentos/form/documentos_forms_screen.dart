import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/matricula_helper.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:flutter/services.dart';

import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

class DocumentosForm extends StatefulWidget {
  DocumentosForm();
  @override
  _DocumentosFormState createState() => _DocumentosFormState();
}

class _DocumentosFormState extends State<DocumentosForm> {
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();
  final int page = 12;

  UserModel membro = new UserModel();
  List<UserModel> listaMembros = [];
  List<UserModel> selecionados = [];

  String idDocumento = '';

  String searchString = '';

  bool isLoading;
  bool isSelectedAll;

  Icon searchIcon = new Icon(
    FeatherIcons.search,
    color: Colors.white,
    size: 24,
  );

  Widget titleSearch = Text(
    '',
    style: TextStyle(
      color: LightStyle.paleta['Branco'],
      fontSize: 14.sp, //20.0,
      fontWeight: FontWeight.w600,
    ),
  );

  TextStyle titleStyle = GoogleFonts.roboto(
    fontSize: 16,
    height: 1.5,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: LightStyle.paleta['Cinza'],
  );

  TextStyle textStyle = TextStyle(
    color: LightStyle.paleta['Branco'],
    height: 1,
    fontSize: 10.sp, //16,
    letterSpacing: 0,
  );

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isSelectedAll = false;
    titleSearch = Text(
      context.read<CustomRouter>().getScreen,
      style: TextStyle(
        color: LightStyle.paleta['Branco'],
        fontSize: 14.sp, //20.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScreen(
      backToPage: page,
      titleSearch: titleSearch,
      fab: fabButton(context),
      actions: [searchButton(context)],
      listView: listagem(context),
    );
  }

  Widget fabButton(BuildContext context) {
    return ElevatedButton(
      onPressed: selecionados.length > 0
          ? !isLoading
              ? () {
                  setState(() => isLoading = true);
                  gerarPdf(
                    context,
                    tipo: context.read<CustomRouter>().getScreen,
                  );
                }
              : () {}
          : null,
      child: !isLoading
          ? Icon(FeatherIcons.printer)
          : SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
    );
  }

  search() async {
    List<UserModel> lista = await MembroRepository().searchTags(searchString);
    setState(() => listaMembros = lista);
  }

  Widget selectAllButton(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
      ),
      child: Checkbox(
        value: isSelectedAll,
        onChanged: (value) {
          setState(() {
            isSelectedAll = value; //!isSelectedAll;
          });
          /*
        setState(() {
          selecionados.contains(membro)
              ? selecionados.remove(membro)
              : selecionados.add(membro);
        });
        */
        },
        checkColor: Theme.of(context).canvasColor,
        activeColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget searchButton(BuildContext context) {
    return IconButton(
      icon: this.searchIcon,
      onPressed: () {
        setState(() {
          if (this.searchIcon.icon == FeatherIcons.search) {
            this.searchIcon =
                new Icon(FeatherIcons.x, color: Colors.white, size: 24);
            this.titleSearch = Container(
              height: 48,
              child: new TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchString = value;
                  });
                  search();
                },
                style: textStyle,
                decoration: InputDecoration(
                    hintText: 'Buscar...',
                    filled: true,
                    fillColor: LightStyle.paleta['BgSecundario'],
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 12.sp, //16,
                      color: LightStyle.paleta['Cinza'],
                      letterSpacing: 0,
                      height: 1,
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyText1,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
              ),
            );
          } else {
            this.searchIcon =
                new Icon(FeatherIcons.search, color: Colors.white, size: 24);
            this.titleSearch = Text(
              context.read<CustomRouter>().getScreen,
              style: Theme.of(context).textTheme.subtitle1,
            );
            this.searchController.text = '';
            this.listaMembros = [];
            this.isSelectedAll = false;
          }
        });
      },
    );
  }

  Widget listagem(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: this.listaMembros.length,
      itemBuilder: (context, index) {
        UserModel membro = this.listaMembros[index];

        return ListTile(
          key: Key(membro.id),
          onTap: () {},
          title: Text(membro.username, style: titleStyle),
          subtitle: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              membro.congregacao != null
                  ? membro.congregacao != ''
                      ? Text(
                          'Congregação: ${context.read<CongregRepository>().getCongreg(membro.congregacao).nome}',
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : SizedBox()
                  : SizedBox(),
              membro?.isDizimista == true
                  ? Text(
                      'Dizimista',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(),
              membro?.tipoMembro != null
                  ? membro?.tipoMembro != ''
                      ? Text(
                          membro.tipoMembro,
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : SizedBox()
                  : SizedBox(),
              membro.situacaoMembro != null
                  ? membro.situacaoMembro != ''
                      ? Text(
                          membro.situacaoMembro,
                          style: Theme.of(context).textTheme.bodyText1,
                        )
                      : SizedBox()
                  : SizedBox(),
              membro.createdAt != null
                  ? Text(
                      'criado em: ${formataData(data: membro.createdAt)}',
                      style: Theme.of(context).textTheme.bodyText1,
                    )
                  : SizedBox(),
              membro?.isVerified == false
                  ? Text(
                      'Não verificado',
                      style: Theme.of(context).textTheme.overline,
                    )
                  : SizedBox(),
              membro?.isActive == false
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
            backgroundImage: membro.profileImageUrl != null
                ? membro.profileImageUrl != ''
                    ? CachedNetworkImageProvider(membro.profileImageUrl)
                    : null
                : null,
            child: membro.profileImageUrl != null
                ? membro.profileImageUrl != ''
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
            value: membro.getIsSelected,
            onChanged: (value) {
              membro.setIsSelected = value; //!membro.getIsSelected;
              setState(() {
                selecionados.contains(membro)
                    ? selecionados.remove(membro)
                    : selecionados.add(membro);
              });
            },
            activeColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }

  snackBar({
    BuildContext context,
    String msg,
    bool isSuccess = true,
  }) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: isSuccess
              ? LightStyle.paleta['Sucesso']
              : Theme.of(context).errorColor,
        ),
      );

  Future<pdf.Widget> cartaoMembroPdf(UserModel membro) async {
    if (membro.matricula == null || membro.matricula == '') {
      membro.matricula = MatriculaHelper(userId: membro.id).getMatricula;
      membro.isMemberCard = true;
      await context
          .read<MembroRepository>()
          .updateMembro(membro: membro, onFail: (e) {}, onSuccess: (uid) {});
    }
    return pdf.Container(
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
            image: pdf.MemoryImage((await rootBundle.load('assets/logo02.png'))
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
                        membro.username,
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
                    membro.matricula,
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
    );
  }

  credencialMinisterioPdf() {}

  cartaApresentacaoPdf() {}

  cartaMudancaPdf() {}

  cartaRecomendacaoPdf() {}

  Future<pdf.Widget> certificadoBatismoPdf(
    UserModel e, {
    int count,
    String certificado,
  }) async {
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
    String linha4 = '${e?.genero != null ? "do sexo ${e?.genero ?? ''}," : ""}';
    String linha5 = 'filh$pronome de ${mae != '' ? mae : ''}';
    String linha6 = '${mae != '' ? pai != '' ? 'e' : '' : ''}';
    String linha7 = '${pai != '' ? pai : ''}';
    String linha8 = 'que de acordo com os ensinamentos bíblicos,';
    String linha9 =
        'foi batizad$pronome no dia ${e.dataBatismoAguas}, tendo dado prova de sua conduta cristã.';
    return pdf.Container(
      height: PdfPageFormat.a4.dimension.y * 0.5 - 1,
      margin: count % 2 == 0 ? pdf.EdgeInsets.only(bottom: 2) : null,
      decoration: pdf.BoxDecoration(
        image: pdf.DecorationImage(
          image: pdf.MemoryImage((await rootBundle.load('assets/batismo.jpg'))
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
                  pdf.Text(
                      'Icoaraci, Belém/PA ${formataData(data: DateTime.now())}.'),
                ],
              ),
            ),
            pdf.Container(
              child: pdf.Row(
                mainAxisAlignment: pdf.MainAxisAlignment.end,
                children: [
                  pdf.Text(
                    'Chave de autenticação $certificado',
                    style: pdf.TextStyle(
                      //font: myFont, //ttf,
                      color: PdfColor.fromHex('#9B9186'),
                      fontSize: 8,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  declaracaoMembroPdf() {}

  Future<void> gerarPdf(
    BuildContext context, {
    String tipo,
  }) async {
    final pdf.Document pw = pdf.Document(deflate: zlib.encode);
    List<pdf.Widget> pdfDocs = [];
    List<UserModel> documentosNaoEmitidos = [];
    int count = 0;

    for (UserModel membro in selecionados) {
      await context.read<DocumentoRepository>().create(
            doc: DocumentoModel(
              membro: membro.id,
              tipo: tipo,
            ),
            onFail: (e) {
              documentosNaoEmitidos.add(membro);
            },
            onSuccess: (uid) async {
              setState(() => idDocumento = uid);
              membro.setIsSelected = false;

              switch (tipo) {
                case 'Cartão de Membro':
                  pdfDocs.add(await cartaoMembroPdf(membro));
                  break;
                case 'Certificado de Batismo':
                  pdfDocs.add(await certificadoBatismoPdf(
                    membro,
                    count: count,
                    certificado: uid,
                  ));
                  break;
              }
            },
          );
      count++;
    }

    switch (tipo) {
      case 'Cartão de Membro':
        pw.addPage(pdf.MultiPage(
            margin: pdf.EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
                  pdf.Center(
                      child: pdf.Container(
                          child: pdf.Wrap(
                    spacing: 1.0,
                    runSpacing: 1.0,
                    children: pdfDocs,
                  )))
                ]));
        break;
      case 'Certificado de Batismo':
        pw.addPage(pdf.MultiPage(
            margin: pdf.EdgeInsets.zero,
            pageFormat: PdfPageFormat.a4,
            build: (context) => [
                  pdf.Container(
                    child: pdf.Column(children: pdfDocs),
                  )
                ]));
        break;
    }

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/documento.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pw.save());

    if (documentosNaoEmitidos.length > 0) {
      snackBar(
        context: context,
        msg: 'Alguns documentos não puderam ser emitidos',
        isSuccess: false,
      );
    } else {
      snackBar(
        context: context,
        msg: 'Todos os documentos foram emitidos com sucesso!',
      );
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfScreen(path),
      ),
    );

    searchController.clear();
    setState(() {
      selecionados = [];
      listaMembros = [];
      searchString = '';
      isLoading = false;
    });
  }
}
