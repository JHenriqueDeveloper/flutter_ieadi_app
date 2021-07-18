import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';

class AreaModel extends BaseModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String nome;
  String setor;
  String sede;
  String supervisor;
  List tags;

  AreaModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.nome,
    this.sede,
    this.setor,
    this.supervisor,
    this.tags,
  });

  @override
  String get getCollection => 'areas';

  @override
  List get getTags => [
    this.id,
    this.nome.toLowerCase(),
    this.sede,
    this.setor,
    this.supervisor,
    this.isActive ? 'ativo' : 'inativo',
  ];

  @override
  get getEmpty => empty;

  static AreaModel empty = AreaModel(
    id: null,
    isActive: true,
    createdAt: DateTime.now(),
    nome: null,
    setor: null,
    sede: null,
    supervisor: null,
    tags: [],
  );

  @override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'nome': nome,
        'setor': setor,
        'sede': sede,
        'supervisor': supervisor,
        'tags': tags,
      };

  factory AreaModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return AreaModel(
      id: doc.id,
      nome: data['nome'] as String,
      setor: data['setor'] as String,
      sede: data['sede'] as String,
      supervisor: data['supervisor'] as String,
      tags: data['tags'] as List,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
    );
  }
}
