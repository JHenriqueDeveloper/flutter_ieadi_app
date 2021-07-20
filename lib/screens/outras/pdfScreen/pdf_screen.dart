import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_extend/share_extend.dart';

class PdfScreen extends StatefulWidget {
  final String path;

  PdfScreen(this.path);

  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  PDFDocument _doc;
  bool _loading;

  @override
  void initState() {
    super.initState();

    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    final doc = await PDFDocument.fromAsset(widget.path);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //String path = context.read<CustomRouter>().getScreen;

    //_initPdf(path);

    return Scaffold(
      appBar: AppBar(
        title: Text('Certificados Gerados'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                iconSize: 24,
                onPressed: () {
                  ShareExtend.share(widget.path, "file",
                      sharePanelTitle: "Enviar PDF", subject: "IEADI-PDF");
                }),
          )
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : PDFViewer(
              scrollDirection: Axis.vertical,
              //showPicker: false,
              pickerButtonColor: Theme.of(context).primaryColor,
              document: _doc,
            ),
    );
  }
}