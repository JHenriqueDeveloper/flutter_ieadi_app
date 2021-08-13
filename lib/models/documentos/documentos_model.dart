import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_ieadi_app/services/services.dart';

class DocumentoModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String membro;
  String tipo;

  List tags;

  //propriedades de carta
  String adic;
  String destinatario;
  String justificativa;
  String assinatura; //quem assina Presidente, Vice-Presidente, Secretário Geral
  bool outroMinisterio;

  DocumentoModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.membro,
    this.tipo,
    this.tags,
    this.adic,
    this.destinatario,
    this.justificativa,
    this.assinatura,
    this.outroMinisterio,
  });

  String _collection = 'documentos';
 // @override
  String get getCollection => _collection;

  //@override
  List get getTags => [
    this.id,
    this.isActive,
    this.createdAt,
    this.membro,
    this.tipo,
    this.adic,
    this.destinatario,
    this.justificativa,
    this.assinatura,
    this.outroMinisterio,
  ];

  //@override
  get getEmpty => empty;

  static DocumentoModel empty = DocumentoModel(
    id: null,
    isActive: true,
    membro: null,
    tipo: null,
    createdAt: DateTime.now(),
    tags: [],
    adic: null,
    destinatario: null,
    justificativa: null,
    assinatura: null,
    outroMinisterio: false,
  );

  //@override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'membro': membro,
        'tipo': tipo,
        'createdAt': Timestamp.fromDate(createdAt),
        'tags': tags,
        'adic': adic,
        'destinatario': destinatario,
        'justificativa': justificativa,
        'assinatura': assinatura,
        'outroMinisterio': outroMinisterio,
      };

  factory DocumentoModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc == null) return null;
    final Map<String, dynamic> data = doc.data();
    return DocumentoModel(
      id: doc.id,
      membro: data['dirigente'] as String,
      tipo: data['idArea'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
      adic: data['adic'] as String,
      destinatario: data['destinatario'] as String,
      justificativa: data['justificativa'] as String,
      assinatura: data['assinatura'] as String,
      outroMinisterio: data['outroMinisterio'] as bool,
    );
  }
}
