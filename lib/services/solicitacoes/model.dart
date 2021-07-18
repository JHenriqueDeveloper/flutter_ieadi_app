import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';

enum STATUS_SOLICITACOES {
  ABERTA,
  RESOLVIDA,
  NAO_RESOLVIDA,
}

enum TIPO_SOLICITACOES {
  CARTA_MUDANCA,
  CARTA_RECOMENDACAO,
  CERTIFICADO_BATISMO,
  CARTAO_MEMBRO,
  CREDENCIAL_MINISTERIO,
  CERTIFICADO_APRESENTACAO,
  DECLARACAO_MEMBRO,
}

class SolicitacoesModel extends BaseModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String solicitante; //id de quem solicitou
  String tipo;
  String status; //Aberta, Resolvida, Não resolvida
  String descricao;
  String imageUrl;
  List tags;

  SolicitacoesModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.solicitante,
    this.tipo,
    this.status,
    this.descricao,
    this.imageUrl,
    this.tags,
  });

  @override
  String get getCollection => 'solicitacoes';
  List get getTags => [
    this.id,
    this.isActive ? 'ativo' : 'inativo',
    this.solicitante,
    this.tipo.toLowerCase(),
    this.status.toLowerCase()
  ];

  @override
  get getEmpty => empty;

  static SolicitacoesModel empty = SolicitacoesModel(
    id: null,
    isActive: true,
    createdAt: DateTime.now(),
    solicitante: null,
    tipo: null,
    status: null,
    descricao: null,
    imageUrl: null,
    tags: [],
  );

  @override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'solicitante': solicitante,
        'tipo': tipo,
        'status': status,
        'descricao': descricao,
        'imageUrl': imageUrl,
        'tags': tags,
      };

  factory SolicitacoesModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return SolicitacoesModel(
      id: doc.id,
      solicitante: data['solicitante'] as String,
      tipo: data['tipo'] as String,
      status: data['status'] as String,
      descricao: data['descricao'] as String,
      imageUrl: data['imageUrl'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
    );
  }
}
