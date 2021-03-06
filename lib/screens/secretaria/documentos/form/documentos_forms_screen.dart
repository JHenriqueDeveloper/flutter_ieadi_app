import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/helpers/matricula_helper.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/helpers/validator.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:flutter/services.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter_ieadi_app/config/config.dart';
import 'package:flutter_ieadi_app/repositories/repositories.dart';
import 'package:flutter_ieadi_app/screens/screens.dart';
import 'package:flutter_ieadi_app/style/style.dart';
import 'package:flutter_ieadi_app/widgets/widgets.dart';

import 'package:printing/printing.dart';

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

  String searchString = '';

  String tipo = '';

  bool isLoading;
  bool isSelectedAll;
  bool onlyOneSelected;

  Icon searchIcon = new Icon(
    FeatherIcons.search,
    color: Colors.white,
    size: 24,
  );

  DocumentoModel documento = new DocumentoModel();
  String idDocumento = '';

  bool isDismiss = true;

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
    onlyOneSelected = false;
    tipo = context.read<CustomRouter>().getScreen;
    if (tipo == 'Carta de Mudan??a' ||
        tipo == 'Carta de Recomenda????o' ||
        tipo == 'Declara????o de Membro') {
      onlyOneSelected = true;
    }
    titleSearch = Text(
      context.read<CustomRouter>().getScreen,
      style: TextStyle(
        color: LightStyle.paleta['Branco'],
        fontSize: 14.sp, //20.0,
        fontWeight: FontWeight.w600,
      ),
    );

    documento.adic = '';
    documento.destinatario = 'Assembl??ia de Deus em..';
    documento.assinatura = 'Presidente';
    documento.outroMinisterio = false;
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

                  if (tipo == 'Carta de Mudan??a' ||
                      tipo == 'Carta de Recomenda????o' || tipo == 'Declara????o de Membro') {
                    if (tipo == 'Carta de Mudan??a') {
                      setState(() {
                        documento.justificativa =
                            'Em tempo informamos que o referido neste documento encontra-se em processo de mudan??a domiciliar, o que justifica o presente documento.';
                      });
                    }

                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.INFO,
                      headerAnimationLoop: false,
                      btnOkText: 'Emitir $tipo',
                      btnOkColor: Theme.of(context).primaryColor,
                      btnOkOnPress: () {
                        setState(() => isDismiss = false);
                        gerarPdf(
                          context,
                          tipo: context.read<CustomRouter>().getScreen,
                        );
                      },
                      body: Builder(
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      child: Text(
                                        'Informa????es da Carta',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 65,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        autocorrect: false,
                                        maxLength: 20,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          labelText: 'N??mero do ADIC/CM',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          fillColor: LightStyle
                                              .paleta['PrimariaCinza'],
                                        ),
                                        validator: (value) =>
                                            Validator.rgValidator(value),
                                        onChanged: (value) =>
                                            documento.adic = value,
                                        initialValue: null,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      height: 65,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        autocorrect: false,
                                        maxLength: 50,
                                        maxLines: 1,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                        decoration: InputDecoration(
                                          labelText: 'Destinat??rio',
                                          labelStyle: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          fillColor: LightStyle
                                              .paleta['PrimariaCinza'],
                                        ),
                                        validator: (value) =>
                                            Validator.rgValidator(value),
                                        onChanged: (value) =>
                                            documento.destinatario = value,
                                        initialValue: documento.destinatario,
                                      ),
                                    ),
                                    //SizedBox(height: 8),
                                    tipo == 'Carta de Mudan??a'
                                        ? ListTile(
                                            title: Text(
                                              'Outro Minist??rio?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                            trailing: Switch(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              onChanged: (e) => setState(() {
                                                documento.outroMinisterio =
                                                    !documento.outroMinisterio;
                                              }),
                                              value: documento.outroMinisterio,
                                            ),
                                          )
                                        : SizedBox(),
                                    tipo == 'Carta de Mudan??a'
                                        ? SizedBox(height: 8)
                                        : SizedBox(),
                                    tipo == 'Carta de Mudan??a'
                                        ? TextFormField(
                                            keyboardType: TextInputType.text,
                                            autocorrect: false,
                                            maxLength: 500,
                                            maxLines: 6,
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Informe a justificativa.',
                                              labelStyle: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                              fillColor: LightStyle
                                                  .paleta['PrimariaCinza'],
                                            ),
                                            onChanged: (value) =>
                                                documento.justificativa = value,
                                            initialValue:
                                                documento.justificativa,
                                          )
                                        : SizedBox(),
                                    //SizedBox(height: 4),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    )..show();

                    if (isDismiss) {
                      //selecionados[0].setIsSelected = false;
                      setState(() {
                        isLoading = false;
                        documento.adic = '';
                        documento.destinatario = 'Assembl??ia de Deus em..';
                        documento.justificativa =
                            'Em tempo informamos que o referido neste documento encontra-se em processo de mudan??a domiciliar, o que justifica o presente documento.';
                        documento.assinatura = 'Presidente';
                        documento.outroMinisterio = false;
                        isDismiss = true;
                        //selecionados = [];
                      });
                    }
                  } else {
                    gerarPdf(
                      context,
                      tipo: context.read<CustomRouter>().getScreen,
                    );
                  }
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

/*
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
  */

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
                          'Congrega????o: ${context.read<CongregRepository>().getCongreg(membro.congregacao).nome}',
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
                      'N??o verificado',
                      style: Theme.of(context).textTheme.overline,
                    )
                  : SizedBox(),
              membro?.isActive == false
                  ? Text(
                      'situa????o: Inativa',
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
            onChanged: selecionados.length > 0 &&
                    !membro.getIsSelected &&
                    onlyOneSelected
                ? null
                : (value) {
                    membro.setIsSelected = value;

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

  Future<pdf.MultiPage> cartaoMembroPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    List<UserModel> documentosNaoEmitidos = [];
    var image = pdf.MemoryImage(
        (await rootBundle.load('assets/logo02.png')).buffer.asUint8List());
    var logo = pdf.MemoryImage(
        (await rootBundle.load('assets/logo01.png')).buffer.asUint8List());
    var assinatura = pdf.MemoryImage(
        (await rootBundle.load('assets/assinatura.png')).buffer.asUint8List());
    var font =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf"));

    return pdf.MultiPage(
        margin: pdf.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                spacing: 40,
                itemBuilder: (context, index) {
                  UserModel membro = this.selecionados[index];

                  if (membro.matricula == null || membro.matricula == '') {
                    membro.matricula =
                        MatriculaHelper(userId: membro.id).getMatricula;
                    membro.isMemberCard = true;
                    var e = () async => await ctx
                        .read<MembroRepository>()
                        .updateMembro(
                            membro: membro,
                            onFail: (e) {},
                            onSuccess: (uid) {});
                    print(e);
                  }

                  this.context.read<DocumentoRepository>().create(
                      doc: DocumentoModel(membro: membro.id, tipo: tipo),
                      onFail: (e) => documentosNaoEmitidos.add(membro),
                      onSuccess: (uid) {
                        setState(() => idDocumento = uid);
                        membro.setIsSelected = false;
                      });

                  return pdf.Row(
                      mainAxisAlignment: pdf.MainAxisAlignment.spaceAround,
                      mainAxisSize: pdf.MainAxisSize.max,
                      children: <pdf.Widget>[
                        //FRENTE
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
                                image: image,
                                fit: pdf.BoxFit.scaleDown,
                              ),
                            ),
                            child: pdf.Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pdf.Row(
                                  children: [
                                    pdf.Column(
                                        crossAxisAlignment:
                                            pdf.CrossAxisAlignment.start,
                                        children: [
                                          pdf.Text(
                                            'AD Icoaraci',
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 10,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                              fontWeight: pdf.FontWeight.bold,
                                            ),
                                          ),
                                          pdf.SizedBox(height: 4),
                                          pdf.Text(
                                            'Membro',
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 8,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                            ),
                                          ),
                                          pdf.SizedBox(height: 4),
                                          pdf.Text(
                                            formataData(
                                                    data: DateTime.now(),
                                                    mask: 'MMM/yyyy')
                                                .toString(),
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 8,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                            ),
                                          ),
                                        ]),
                                    pdf.Spacer(),
                                    pdf.Container(
                                      width: 48,
                                      height: 48,
                                      decoration: pdf.BoxDecoration(
                                        image: pdf.DecorationImage(
                                          image: logo,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pdf.Spacer(),
                                pdf.Container(
                                  child: pdf.Column(
                                    crossAxisAlignment:
                                        pdf.CrossAxisAlignment.start,
                                    mainAxisSize: pdf.MainAxisSize.max,
                                    children: [
                                      pdf.Row(
                                        children: [
                                          pdf.Text(
                                            membro.username,
                                            style: pdf.TextStyle(
                                              font: font,
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
                                          font: font,
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
                        //VERSO
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
                            child: pdf.Column(
                              children: [
                                //pdf.SizedBox(height: 8),
                                pdf.Row(
                                    mainAxisSize: pdf.MainAxisSize.max,
                                    children: [
                                      pdf.Container(
                                        width: 36,
                                        height: 36,
                                        child: membro.avatar != null
                                            ? pdf.Image(membro.avatar)
                                            : pdf.Image(logo),
                                        decoration: pdf.BoxDecoration(
                                          borderRadius: pdf.BorderRadius.all(
                                            pdf.Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      pdf.SizedBox(width: 12),
                                      pdf.Column(
                                          crossAxisAlignment:
                                              pdf.CrossAxisAlignment.start,
                                          children: [
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Natural de',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.naturalidade ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Estado Civil',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.estadoCivil ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Nascimento',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.dataNascimento ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'CPF',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.cpf ?? 'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                          ]),
                                    ]),
                                pdf.SizedBox(height: 4),
                                pdf.Text(
                                  'Esta identidade s?? ter?? validade, enquanto o portador, conservar-se fiel aos princ??pios bibl??cos e manter-se vinculado ?? esta entidade. \nFora do campo de Icoaraci ?? necess??rio carta de recomenda????o atualizada e RG. \nAtos 2.41-42: Os que lhe aceitaram a palavra e foram batizados. Havendo um acr??scimo naquele dia aproximado a tr??s mil pessoas. E perseveraram na doutrina dos ap??stolos e na comunh??o, no partir do p??o e nas ora????es.',
                                  style: pdf.TextStyle(
                                    font: font,
                                    fontSize: 3,
                                    letterSpacing: 0,
                                    color: PdfColorCmyk(0.0, 0.0, 0.0, 0.04),
                                    height: 1.5,
                                  ),
                                ),
                                pdf.SizedBox(height: 6),
                                pdf.Container(
                                  color: PdfColorCmyk(0.0, 0.0, 0.0, 0.04),
                                  height: 18,
                                  width: 227,
                                  padding: pdf.EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 6,
                                  ),
                                  child: pdf.Text(
                                    'Assinatura',
                                    style: pdf.TextStyle(
                                      font: font,
                                      fontSize: 8,
                                      letterSpacing: 0,
                                      color: PdfColorCmyk(0.0, 0.0, 0.0, 0.5),
                                      height: 1.5,
                                    ),
                                  ),
                                ),

                                pdf.SizedBox(height: 6),
                                pdf.Container(
                                  width: 227,
                                  height: 18,
                                  //color: PdfColorCmyk(0.0, 0.0, 0.0, 1),
                                  child: pdf.Image(assinatura),
                                  decoration: pdf.BoxDecoration(
                                    image: pdf.DecorationImage(
                                      image: assinatura,
                                      fit: pdf.BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]);
                })
          ];
        });
  }

  Future<pdf.MultiPage> credencialMinisterioPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    List<UserModel> documentosNaoEmitidos = [];
    var frente = pdf.MemoryImage(
        (await rootBundle.load('assets/cartao_m.png')).buffer.asUint8List());
    var verso = pdf.MemoryImage(
        (await rootBundle.load('assets/cartao_m_verso.png'))
            .buffer
            .asUint8List());
    var logo = pdf.MemoryImage(
        (await rootBundle.load('assets/logo01.png')).buffer.asUint8List());
    var assinatura = pdf.MemoryImage(
        (await rootBundle.load('assets/assinatura.png')).buffer.asUint8List());
    var font =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Regular.ttf"));

    return pdf.MultiPage(
        margin: pdf.EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        pageFormat: PdfPageFormat.a4,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                spacing: 40,
                itemBuilder: (context, index) {
                  UserModel membro = this.selecionados[index];

                  if (membro.matricula == null || membro.matricula == '') {
                    membro.matricula =
                        MatriculaHelper(userId: membro.id).getMatricula;
                    membro.isMemberCard = true;
                    var e = () async => await ctx
                        .read<MembroRepository>()
                        .updateMembro(
                            membro: membro,
                            onFail: (e) {},
                            onSuccess: (uid) {});
                    print(e);
                  }

                  this.context.read<DocumentoRepository>().create(
                      doc: DocumentoModel(membro: membro.id, tipo: tipo),
                      onFail: (e) => documentosNaoEmitidos.add(membro),
                      onSuccess: (uid) {
                        setState(() => idDocumento = uid);
                        membro.setIsSelected = false;
                      });

                  return pdf.Row(
                      mainAxisAlignment: pdf.MainAxisAlignment.spaceAround,
                      mainAxisSize: pdf.MainAxisSize.max,
                      children: <pdf.Widget>[
                        //FRENTE
                        pdf.Container(
                          width: 227,
                          height: 142,
                          decoration: pdf.BoxDecoration(
                            borderRadius: pdf.BorderRadius.all(
                              pdf.Radius.circular(20),
                            ),
                            image: pdf.DecorationImage(
                              image: frente,
                              fit: pdf.BoxFit.scaleDown,
                            ),
                          ),
                          padding: pdf.EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 25,
                          ),
                          child: pdf.Container(
                            child: pdf.Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                pdf.Row(
                                  children: [
                                    pdf.Column(
                                        crossAxisAlignment:
                                            pdf.CrossAxisAlignment.start,
                                        children: [
                                          pdf.Text(
                                            'AD Icoaraci',
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 10,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                              fontWeight: pdf.FontWeight.bold,
                                            ),
                                          ),
                                          pdf.SizedBox(height: 4),
                                          pdf.Text(
                                            'Credencial do Minist??rio',
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 8,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                            ),
                                          ),
                                          pdf.SizedBox(height: 4),
                                          pdf.Text(
                                            formataData(
                                                    data: DateTime.now(),
                                                    mask: 'MMM/yyyy')
                                                .toString(),
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 8,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
                                              height: 1.5,
                                            ),
                                          ),
                                        ]),
                                    pdf.Spacer(),
                                  ],
                                ),
                                pdf.Spacer(),
                                pdf.Container(
                                  child: pdf.Column(
                                    crossAxisAlignment:
                                        pdf.CrossAxisAlignment.start,
                                    mainAxisSize: pdf.MainAxisSize.max,
                                    children: [
                                      pdf.Row(
                                        children: [
                                          pdf.Text(
                                            membro.username,
                                            style: pdf.TextStyle(
                                              font: font,
                                              fontSize: 10,
                                              letterSpacing: 0,
                                              color: PdfColor.fromHex('ffffff'),
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
                                          font: font,
                                          fontSize: 12,
                                          letterSpacing: 0,
                                          color: PdfColor.fromHex('ffffff'),
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
                        //VERSO
                        pdf.Container(
                          width: 227,
                          height: 142,
                          decoration: pdf.BoxDecoration(
                            borderRadius: pdf.BorderRadius.all(
                              pdf.Radius.circular(20),
                            ),
                            image: pdf.DecorationImage(
                              image: verso,
                              fit: pdf.BoxFit.scaleDown,
                            ),
                          ),
                          padding: pdf.EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: pdf.Container(
                            child: pdf.Column(
                              children: [
                                //pdf.SizedBox(height: 8),
                                pdf.Row(
                                    mainAxisSize: pdf.MainAxisSize.max,
                                    children: [
                                      pdf.Container(
                                        width: 36,
                                        height: 36,
                                        child: membro.avatar != null
                                            ? pdf.Image(membro.avatar)
                                            : pdf.Image(logo),
                                        decoration: pdf.BoxDecoration(
                                          borderRadius: pdf.BorderRadius.all(
                                            pdf.Radius.circular(20),
                                          ),
                                        ),
                                      ),
                                      pdf.SizedBox(width: 12),
                                      pdf.Column(
                                          crossAxisAlignment:
                                              pdf.CrossAxisAlignment.start,
                                          children: [
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Natural de',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.naturalidade ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Estado Civil',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.estadoCivil ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'Nascimento',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.dataNascimento ??
                                                    'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                            //pdf.SizedBox(height: 2),
                                            pdf.Row(children: [
                                              pdf.Text(
                                                'CPF',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                              pdf.SizedBox(width: 4),
                                              pdf.Text(
                                                membro?.cpf ?? 'N??o informado',
                                                style: pdf.TextStyle(
                                                  font: font,
                                                  fontSize: 8,
                                                  fontWeight:
                                                      pdf.FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: PdfColorCmyk(
                                                      0.0, 0.0, 0.0, 0.04),
                                                  height: 1.5,
                                                ),
                                              ),
                                            ]),
                                          ]),
                                    ]),
                                pdf.SizedBox(height: 4),
                                pdf.Text(
                                  'CONSTITUI????O 1988 REPUBLICA FEDERATIVA DO BRASIL\nEntrada em hospitais e pres??dios : art V.VII - ?? assegurada nos termos da lei a presta????o de assist??ncia religiosa nas entidades civis e militares de interna????o coletiva.\nLIBERDADE DE CULTO\nart V.VI - ?? inviol??vel a liberdade de consci??ncia e de cren??a, sendo assegurado o livre exerc??cio de cultos religiosos.\n?? garantida na forma da lei a prote????o aos locais de culto e ??s suas liturgias.\nEsta identidade s?? ter?? validade, enquanto o portador, conservar-se fiel aos princ??pios bibl??cos e manter-se vinculado ?? esta entidade. \nFora do campo de Icoaraci ?? necess??rio carta de recomenda????o atualizada e RG.',
                                  style: pdf.TextStyle(
                                    font: font,
                                    fontSize: 3,
                                    letterSpacing: 0,
                                    color: PdfColorCmyk(0.0, 0.0, 0.0, 0.04),
                                    height: 1.5,
                                  ),
                                ),
                                pdf.SizedBox(height: 6),
                                pdf.Container(
                                  color: PdfColorCmyk(0.0, 0.0, 0.0, 0.04),
                                  height: 18,
                                  width: 227,
                                  padding: pdf.EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 6,
                                  ),
                                  child: pdf.Text(
                                    'Assinatura',
                                    style: pdf.TextStyle(
                                      font: font,
                                      fontSize: 8,
                                      letterSpacing: 0,
                                      color: PdfColorCmyk(0.0, 0.0, 0.0, 0.5),
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                                pdf.SizedBox(height: 2),
                                pdf.Container(
                                  width: 227,
                                  height: 9,
                                  child: pdf.Image(assinatura),
                                  decoration: pdf.BoxDecoration(
                                    image: pdf.DecorationImage(
                                      image: assinatura,
                                      fit: pdf.BoxFit.scaleDown,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ]);
                })
          ];
        });
  }

  Future<pdf.MultiPage> certificadoBatismoPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    var bg = pdf.MemoryImage(
        (await rootBundle.load('assets/certificado.png')).buffer.asUint8List());

    var font1 =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Light.ttf"));
    var font2 = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));

    return pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdf.EdgeInsets.zero,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                padding: pdf.EdgeInsets.zero,
                spacing: 1,
                itemBuilder: (context, index) {
                  UserModel e = this.selecionados[index];

                  String pronome = e.genero != null
                      ? e.genero == 'Masculino'
                          ? 'o'
                          : 'a'
                      : 'o(a)';
                  String mae = '${e.nomeMae ?? ''}';
                  String pai = '${e.nomePai ?? ''}';

                  String linha1 =
                      '??s fls. ${e?.paginaRegistro ?? '00'} do livro n?? ${e?.livroRegistro ?? '000'} de Membros desta igreja foi registrad$pronome,';
                  String linha2 = formataNome(e.username, insertDot: true);
                  // '${e.username}';
                  String linha3 =
                      '${e?.dataNascimento != null ? "Nascid$pronome no dia ${e?.dataNascimento ?? '00'}," : ''}';
                  String linha4 =
                      '${e?.genero != null ? "do sexo ${e?.genero ?? ''}," : ""}';
                  String linha5 = 'filh$pronome de ${mae != '' ? mae : ''}';
                  String linha6 = '${mae != '' ? pai != '' ? 'e' : '' : ''}';
                  String linha7 = '${pai != '' ? pai : ''}';
                  String linha8 =
                      ', que de acordo com os ensinamentos b??blicos,';
                  String linha9 =
                      'foi batizad$pronome no dia ${e.dataBatismoAguas}, tendo dado prova de sua conduta crist??.';

                  return pdf.Container(
                    height: PdfPageFormat.a4.dimension.y * 0.5 - 1,
                    width: PdfPageFormat.a4.dimension.x,
                    decoration: pdf.BoxDecoration(
                      image: pdf.DecorationImage(
                        image: bg,
                        fit: pdf.BoxFit.cover,
                      ),
                    ),
                    child: pdf.Container(
                        padding: pdf.EdgeInsets.symmetric(
                          vertical: 130,
                        ),
                        width: 500,
                        height: 300,
                        //color: PdfColors.red,
                        child: pdf.Column(
                            mainAxisAlignment: pdf.MainAxisAlignment.start,
                            crossAxisAlignment: pdf.CrossAxisAlignment.center,
                            children: [
                              pdf.Text(
                                linha1,
                                textAlign: pdf.TextAlign.center,
                                style: pdf.TextStyle(
                                  font: font1,
                                  fontSize: 9.6,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.4,
                                ),
                              ),
                              pdf.SizedBox(height: 16),
                              pdf.Text(
                                linha2.toUpperCase(),
                                textAlign: pdf.TextAlign.center,
                                style: pdf.TextStyle(
                                  font: font2,
                                  fontSize: 30.8,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.4,
                                ),
                              ),
                              pdf.SizedBox(height: 16),
                              pdf.Container(
                                padding: pdf.EdgeInsets.symmetric(
                                  horizontal: 120,
                                ),
                                child: pdf.Text(
                                  '$linha3 $linha4 $linha5 $linha6 $linha7 $linha8 $linha9',
                                  textAlign: pdf.TextAlign.center,
                                  style: pdf.TextStyle(
                                    font: font1,
                                    fontSize: 8.4,
                                    letterSpacing: 0,
                                    color: PdfColor.fromHex('#364d65'),
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              pdf.SizedBox(height: 16),
                              pdf.Text(
                                'Icoaraci, Bel??m/PA ${formataData(data: DateTime.now())}',
                                textAlign: pdf.TextAlign.center,
                                style: pdf.TextStyle(
                                  font: font1,
                                  fontSize: 8.4,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.4,
                                ),
                              ),
                              pdf.Text(
                                'Chave de autentica????o: ${e.idDoc}',
                                textAlign: pdf.TextAlign.center,
                                style: pdf.TextStyle(
                                  font: font1,
                                  fontSize: 8.4,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.4,
                                ),
                              ),
                            ])),
                  );
                })
          ];
        });
  }

  Future<pdf.MultiPage> cartaMudancaPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    var bg = pdf.MemoryImage(
        (await rootBundle.load('assets/timbre.png')).buffer.asUint8List());

    var font1 =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Light.ttf"));
    var fontBold =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Bold.ttf"));
    var font2 = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));
    var aleoBold = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));

    return pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdf.EdgeInsets.zero,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                padding: pdf.EdgeInsets.zero,
                spacing: 1,
                itemBuilder: (context, index) {
                  UserModel e = this.selecionados[index];

                  String adic = this.documento.adic;

                  String destinatario = this.documento.destinatario;
                  String justificativa = this.documento.justificativa;

                  String header =
                      'Chave de autentica????o: ${e.idDoc}\n\nIcoaraci, Bel??m/PA ${formataData(data: DateTime.now())}\n\nADIC/CM N?? $adic/${DateTime.now().year}\n\n?? $destinatario.';

                  String titulo = 'CARTA DE MUDAN??A';
                  String conteudo =
                      '                  A Igreja Evang??lica Assembl??ia de Deus em Icoaraci, Bel??m/PA , Apresenta com carta de mudan??a ${formataNome(e.username, insertDot: true)}, membro desta Igreja, que at?? a presente data n??o h?? nada que desabone a sua conduta crist??.\n\n                $justificativa\n\n\nSem mais para o momento.';

                  setState(() {
                    documento.adic = '';
                    documento.destinatario = 'Assembl??ia de Deus em..';
                    documento.justificativa =
                        'Em tempo informamos que o referido neste documento encontra-se em processo de mudan??a domiciliar, o que justifica o presente documento.';
                    documento.assinatura = 'Presidente';
                    documento.outroMinisterio = false;
                    isDismiss = true;
                  });

                  return pdf.Container(
                    height: PdfPageFormat.a4.dimension.y,
                    width: PdfPageFormat.a4.dimension.x,
                    decoration: pdf.BoxDecoration(
                      image: pdf.DecorationImage(
                        image: bg,
                        fit: pdf.BoxFit.cover,
                      ),
                    ),
                    child: pdf.Container(
                        padding: pdf.EdgeInsets.symmetric(
                          vertical: 140,
                          horizontal: 60,
                        ),
                        child: pdf.Column(
                            mainAxisAlignment: pdf.MainAxisAlignment.start,
                            crossAxisAlignment: pdf.CrossAxisAlignment.start,
                            children: [
                              pdf.Text(
                                header,
                                style: pdf.TextStyle(
                                  font: fontBold,
                                  fontSize: 9.6,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.5,
                                ),
                              ),
                              pdf.SizedBox(height: 64),
                              pdf.Column(
                                  crossAxisAlignment:
                                      pdf.CrossAxisAlignment.center,
                                  children: [
                                    pdf.Text(
                                      titulo.toUpperCase(),
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: font2,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Text(
                                      conteudo,
                                      style: pdf.TextStyle(
                                        font: font1,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Container(
                                      width: 200,
                                      margin:
                                          const pdf.EdgeInsets.only(bottom: 8),
                                      decoration: pdf.BoxDecoration(
                                        border: pdf.Border.all(
                                          color: PdfColor.fromHex('#364d65'),
                                        ),
                                      ),
                                    ),
                                    pdf.Text(
                                      'CARLOS ARY ALVEZ GOMES',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: aleoBold,
                                        fontSize: 9.6,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 4),
                                    pdf.Text(
                                      'Pastor Presidente',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: fontBold,
                                        fontSize: 9.2,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                  ]),
                            ])),
                  );
                })
          ];
        });
  }

  Future<pdf.MultiPage> cartaRecomendacaoPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    var bg = pdf.MemoryImage(
        (await rootBundle.load('assets/timbre.png')).buffer.asUint8List());

    var font1 =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Light.ttf"));
    var fontBold =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Bold.ttf"));
    var font2 = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));
    var aleoBold = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));

    return pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdf.EdgeInsets.zero,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                padding: pdf.EdgeInsets.zero,
                spacing: 1,
                itemBuilder: (context, index) {
                  UserModel e = this.selecionados[index];

                  String pronome = e.genero != null
                      ? e.genero == 'Masculino'
                          ? 'o'
                          : 'a'
                      : 'o(a)';

                  String adic = this.documento.adic;
                  String destinatario = this.documento.destinatario;

                  String header =
                      'Chave de autentica????o: ${e.idDoc}\n\nIcoaraci, Bel??m/PA ${formataData(data: DateTime.now())}\n\nADIC/CM N?? $adic/${DateTime.now().year}\n\n?? $destinatario.';

                  String titulo = 'CARTA DE RECOMENDA????O';
                  String conteudo =
                      '                  A Igreja Evang??lica Assembl??ia de Deus em Icoaraci, Bel??m/PA , Apresenta com carta de recomenda????o ${formataNome(e.username, insertDot: true)}, membro desta Igreja, que at?? a presente data n??o h?? nada que desabone a sua conduta crist?? e encontra-se em plena comunh??o.\n\n                  N??s $pronome recomendamos para que $pronome recebais no Senhor, como usam fazer os santos.\n\n\n                  Atenciosamente.';

                  setState(() {
                    documento.adic = '';
                    documento.destinatario = 'Assembl??ia de Deus em..';
                    documento.assinatura = 'Presidente';
                    isDismiss = true;
                  });

                  return pdf.Container(
                    height: PdfPageFormat.a4.dimension.y,
                    width: PdfPageFormat.a4.dimension.x,
                    decoration: pdf.BoxDecoration(
                      image: pdf.DecorationImage(
                        image: bg,
                        fit: pdf.BoxFit.cover,
                      ),
                    ),
                    child: pdf.Container(
                        padding: pdf.EdgeInsets.symmetric(
                          vertical: 140,
                          horizontal: 60,
                        ),
                        child: pdf.Column(
                            mainAxisAlignment: pdf.MainAxisAlignment.start,
                            crossAxisAlignment: pdf.CrossAxisAlignment.start,
                            children: [
                              pdf.Text(
                                header,
                                style: pdf.TextStyle(
                                  font: fontBold,
                                  fontSize: 9.6,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.5,
                                ),
                              ),
                              pdf.SizedBox(height: 64),
                              pdf.Column(
                                  crossAxisAlignment:
                                      pdf.CrossAxisAlignment.center,
                                  children: [
                                    pdf.Text(
                                      titulo.toUpperCase(),
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: font2,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Text(
                                      conteudo,
                                      style: pdf.TextStyle(
                                        font: font1,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Container(
                                      width: 200,
                                      margin:
                                          const pdf.EdgeInsets.only(bottom: 8),
                                      decoration: pdf.BoxDecoration(
                                        border: pdf.Border.all(
                                          color: PdfColor.fromHex('#364d65'),
                                        ),
                                      ),
                                    ),
                                    pdf.Text(
                                      'CARLOS ARY ALVEZ GOMES',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: aleoBold,
                                        fontSize: 9.6,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 4),
                                    pdf.Text(
                                      'Pastor Presidente',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: fontBold,
                                        fontSize: 9.2,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                  ]),
                            ])),
                  );
                })
          ];
        });
  }

  Future<pdf.MultiPage> declaracaoMembroPdf(
    BuildContext ctx,
    String tipo,
  ) async {
    var bg = pdf.MemoryImage(
        (await rootBundle.load('assets/timbre.png')).buffer.asUint8List());

    var font1 =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Light.ttf"));
    var fontBold =
        pdf.Font.ttf(await rootBundle.load("assets/OpenSans-Bold.ttf"));
    var font2 = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));
    var aleoBold = pdf.Font.ttf(await rootBundle.load("assets/Aleo-Bold.ttf"));

    return pdf.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pdf.EdgeInsets.zero,
        build: (pdf.Context context) {
          return [
            pdf.ListView.builder(
                itemCount: this.selecionados.length,
                padding: pdf.EdgeInsets.zero,
                spacing: 1,
                itemBuilder: (context, index) {
                  UserModel e = this.selecionados[index];

                  String adic = this.documento.adic;
                  String destinatario = this.documento.destinatario;

                  String header =
                      'Chave de autentica????o: ${e.idDoc}\n\nIcoaraci, Bel??m/PA ${formataData(data: DateTime.now())}\n\nADIC/CM N?? $adic/${DateTime.now().year}\n\n?? $destinatario.';

                  String titulo = 'DECLARA????O DE MEMBRO';
                  String conteudo =
                      '                  A Igreja Evang??lica Assembl??ia de Deus em Icoaraci, Bel??m/PA , declara para os devidos fins, que ${formataNome(e.username, insertDot: true)}, portador do CPF ${e?.cpf ?? 'N??O INFORMADO'} ?? membro desta Igreja.\n\n\n                  Atenciosamente.';

                  setState(() {
                    documento.adic = '';
                    documento.destinatario = 'Assembl??ia de Deus em..';
                    documento.assinatura = 'Presidente';
                    isDismiss = true;
                  });

                  return pdf.Container(
                    height: PdfPageFormat.a4.dimension.y,
                    width: PdfPageFormat.a4.dimension.x,
                    decoration: pdf.BoxDecoration(
                      image: pdf.DecorationImage(
                        image: bg,
                        fit: pdf.BoxFit.cover,
                      ),
                    ),
                    child: pdf.Container(
                        padding: pdf.EdgeInsets.symmetric(
                          vertical: 140,
                          horizontal: 60,
                        ),
                        child: pdf.Column(
                            mainAxisAlignment: pdf.MainAxisAlignment.start,
                            crossAxisAlignment: pdf.CrossAxisAlignment.start,
                            children: [
                              pdf.Text(
                                header,
                                style: pdf.TextStyle(
                                  font: fontBold,
                                  fontSize: 9.6,
                                  letterSpacing: 0,
                                  color: PdfColor.fromHex('#364d65'),
                                  height: 1.5,
                                ),
                              ),
                              pdf.SizedBox(height: 64),
                              pdf.Column(
                                  crossAxisAlignment:
                                      pdf.CrossAxisAlignment.center,
                                  children: [
                                    pdf.Text(
                                      titulo.toUpperCase(),
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: font2,
                                        fontSize: 18,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Text(
                                      conteudo,
                                      style: pdf.TextStyle(
                                        font: font1,
                                        fontSize: 12,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 64),
                                    pdf.Container(
                                      width: 200,
                                      margin:
                                          const pdf.EdgeInsets.only(bottom: 8),
                                      decoration: pdf.BoxDecoration(
                                        border: pdf.Border.all(
                                          color: PdfColor.fromHex('#364d65'),
                                        ),
                                      ),
                                    ),
                                    pdf.Text(
                                      'CARLOS ARY ALVEZ GOMES',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: aleoBold,
                                        fontSize: 9.6,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                    pdf.SizedBox(height: 4),
                                    pdf.Text(
                                      'Pastor Presidente',
                                      textAlign: pdf.TextAlign.center,
                                      style: pdf.TextStyle(
                                        font: fontBold,
                                        fontSize: 9.2,
                                        letterSpacing: 0,
                                        color: PdfColor.fromHex('#364d65'),
                                        height: 1.5,
                                      ),
                                    ),
                                  ]),
                            ])),
                  );
                })
          ];
        });
  }

  Future<void> gerarPdf(
    BuildContext context, {
    String tipo,
  }) async {
    final pdf.Document pw = pdf.Document(deflate: zlib.encode);
    List<UserModel> documentosNaoEmitidos = [];

    List<UserModel> listagemAvatar = [];

    Future<String> idDoc(UserModel membro) async {
      String id = '';
      documento.membro = membro.id;
      documento.tipo = tipo;

      await context.read<DocumentoRepository>().create(
          doc: documento,
          onFail: (e) {},
          onSuccess: (uid) {
            setState(() => idDocumento = uid);
            membro.setIsSelected = false;
            id = uid;
          });

      return id;
    }

    for (UserModel e in selecionados) {
      if (e.profileImageUrl != '' && e.profileImageUrl != null) {
        e.avatar = await networkImage(e.profileImageUrl);
      }
      e.idDoc = await idDoc(e);
      listagemAvatar.add(e);
    }

    setState(() {
      selecionados = listagemAvatar;
    });

    switch (tipo) {
      case 'Cart??o de Membro':
        pw.addPage(await cartaoMembroPdf(context, tipo));
        break;
      case 'Credencial do Minist??rio':
        pw.addPage(await credencialMinisterioPdf(context, tipo));
        break;
      case 'Certificado de Batismo':
        pw.addPage(await certificadoBatismoPdf(context, tipo));
        break;
      case 'Certificado de \nApresenta????o':
        break;
      case 'Carta de Mudan??a':
        setState(() => isLoading = true);
        UserModel e = listagemAvatar[0];

        e.situacaoMembro = documento.outroMinisterio
            ? 'Mudou de Minist??rio'
            : 'Mudou de Campo';
        e.isActive = false;

        e.dataMudanca = DateTime.now().toString();

        await context
            .read<MembroRepository>()
            .updateMembro(membro: e, onFail: (e) {}, onSuccess: (uid) {});

        pw.addPage(await cartaMudancaPdf(context, tipo));

        setState(() => isLoading = true);
        break;
      case 'Carta de Recomenda????o':
        pw.addPage(await cartaRecomendacaoPdf(context, tipo));
        break;
      case 'Declara????o de Membro':
        pw.addPage(await declaracaoMembroPdf(context, tipo));
        break;
      default:
        print('null');
        break;
    }

    setState(() {
      selecionados = [];
    });

/*
    for (UserModel membro in selecionados) {
      await context.read<DocumentoRepository>().create(
            doc: DocumentoModel(
              membro: membro.id,
              tipo: tipo,
            ),
            onFail: (e) {
              documentosNaoEmitidos.add(membro);
              print('n??o emitido: ${membro.username}');
            },
            onSuccess: (uid) async {
              setState(() => idDocumento = uid);
              membro.setIsSelected = false;

              print('emitido: ${membro.username}');

              if (tipo == 'Cart??o de Membro')
                pdfDocs.add(await cartaoMembroPdf(membro));

              if (tipo == 'Certificado de Batismo')
                pdfDocs.add(await certificadoBatismoPdf(
                  membro,
                  count: count,
                  certificado: uid,
                ));

              print('dentro do for: ${pdfDocs.length}');
              count++;
            },
          );
    }

    print('total: ${pdfDocs.length}');
*/
/*
    switch (tipo) {
      case 'Cart??o de Membro':
        pw.addPage(pdf.MultiPage(
            margin: pdf.EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            pageFormat: PdfPageFormat.a4,
            build: (pdf.Context context) {
              print(pdfDocs.length);
              return [
                pdf.Center(
                    child: pdf.Container(
                        child: pdf.Wrap(
                  spacing: 1.0,
                  runSpacing: 1.0,
                  children: pdfDocs,
                ))),
              ];
            }));
        break;
      case 'Certificado de Batismo':
        pw.addPage(pdf.MultiPage(
            margin: pdf.EdgeInsets.zero,
            pageFormat: PdfPageFormat.a4,
            build: (pdf.Context context) {
              print(pdfDocs.length);
              return [
                pdf.Container(
                  child: pdf.Column(children: pdfDocs),
                )
              ];
            }));
        break;
    }
*/
    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/documento.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pw.save());

    if (documentosNaoEmitidos.length > 0) {
      snackBar(
        context: context,
        msg: 'Alguns documentos n??o puderam ser emitidos',
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
