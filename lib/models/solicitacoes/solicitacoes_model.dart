import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitacoesModel {
  String id;
  String solicitante; //id de quem solicitou
  String tipo;
  String status; //Aberta, Resolvida, Não resolvida
  String descricao;
  String imageUrl;
  bool isActive;
  DateTime createdAt;

  SolicitacoesModel({
    this.id,
    this.solicitante,
    this.tipo,
    this.status,
    this.descricao,
    this.imageUrl,
    this.isActive,
    this.createdAt,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('solicitacoes/${this.id}');

  Map<String, dynamic> toDocument() => {
        'solicitante': solicitante,
        'tipo': tipo,
        'status': status,
        'descricao': descricao,
        'imageUrl': imageUrl,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  get getEmpty => empty;

  static SolicitacoesModel empty = SolicitacoesModel(
    id: null,
    solicitante: null,
    tipo: '',
    status: '',
    descricao: '',
    imageUrl: '',
    isActive: true,
    createdAt: DateTime.now(),
  );

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
    );
  }

  static Future<SolicitacoesModel> getSolicitacoes(String id) async {
    if (id != null) {
      final doc =
          await FirebaseFirestore.instance.doc('solicitacoes/$id').get();
      return doc.exists
          ? SolicitacoesModel.fromDocument(doc)
          : SolicitacoesModel.empty;
    }
    return SolicitacoesModel.empty;
  }

  Future<void> save() async => await firestoreRef.set(toDocument());

  Future<void> update(SolicitacoesModel solicitacao) async {
    return await FirebaseFirestore.instance
        .doc('solicitacoes/${solicitacao.id}')
        .update(solicitacao.toDocument());
  }
}
