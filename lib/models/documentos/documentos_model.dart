import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter_ieadi_app/services/services.dart';

class DocumentoModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String membro;
  String tipo;
  List tags;

  DocumentoModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.membro,
    this.tipo,
    this.tags,
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
  );

  //@override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'membro': membro,
        'tipo': tipo,
        'createdAt': Timestamp.fromDate(createdAt),
        'tags': tags,
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
    );
  }
}
