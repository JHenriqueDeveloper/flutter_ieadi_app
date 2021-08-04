import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';

class SetorModel extends BaseModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String nome;
  String sede;
  String supervisor;
  List tags;

  SetorModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.nome,
    this.sede,
    this.supervisor,
    this.tags,
  });

  @override
  String get getCollection => 'setores';

  @override
  List get getTags => [
    this.id,
    this.isActive ? 'ativo' : 'inativo',
    this.nome.toLowerCase(),
    this.sede,
    this.supervisor,
  ];

  @override
  get getEmpty => empty;

  static SetorModel empty = SetorModel(
    id: null,
    isActive: true,
    createdAt: DateTime.now(),
    nome: null,
    sede: null,
    supervisor: null,
    tags: [],
  );

  @override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'nome': nome,
        'sede': sede,
        'supervisor': supervisor,
        'tags': tags,
      };

  factory SetorModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc == null) return null;
    final Map<String, dynamic> data = doc.data();
    return SetorModel(
      id: doc.id,
      nome: data['nome'] as String,
      sede: data['sede'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
    );
  }
}
