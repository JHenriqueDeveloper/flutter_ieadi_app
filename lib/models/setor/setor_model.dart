import 'package:cloud_firestore/cloud_firestore.dart';

class SetorModel {
  String id;
  String nome;
  String sede;
  String supervisor;
  //configurações
  bool isActive;
  DateTime createdAt;

  SetorModel({
    this.id,
    this.nome,
    this.sede,
    this.supervisor,
    this.isActive,
    this.createdAt,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('setores/${this.id}');

  get getId => id;
  get getNome => nome;
  get getSede => sede;
  get getSupervisor => supervisor;
  get getIsActive => isActive;
  get getCreatedAt => createdAt;

  set setId(String id) => this.id = id;
  set setNome(String nome) => this.nome = nome;
  set setSede(String sede) => this.sede = sede;
  set setSupervisor(String supervisor) => this.supervisor = supervisor;
  set setIsactive(bool isActive) => this.isActive = isActive;
  set setCreatedAt(DateTime createdAt) => this.createdAt = createdAt;

  Map<String, dynamic> toDocument() => {
        'nome': nome,
        'sede': sede,
        'supervisor': supervisor,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  get getEmpty => empty;

  static SetorModel empty = SetorModel(
    id: '',
    nome: '',
    sede: '',
    supervisor: '',
    isActive: false,
    createdAt: DateTime.now(),
  );

  factory SetorModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return SetorModel(
      id: doc.id,
      nome: data['nome'] as String,
      sede: data['sede'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
    );
    
  }

  static Future<SetorModel> getSetor(String setorId) async {
    final doc = await FirebaseFirestore.instance.doc('setores/$setorId').get();
    return doc.exists ? SetorModel.fromDocument(doc) : SetorModel.empty;
  }

  Future<void> saveSetor() async => await firestoreRef.set(toDocument());

  Future<void> updateSetor(SetorModel setor) async {
    return await FirebaseFirestore.instance
        .doc('setores/${setor.id}')
        .update(setor.toDocument());
  }
}
