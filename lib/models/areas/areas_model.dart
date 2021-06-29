import 'package:cloud_firestore/cloud_firestore.dart';

class AreasModel {
  String id;
  String nome;
  String setor;
  String sede;
  String supervisor;
  //configurações
  bool isActive;
  DateTime createdAt;

  AreasModel({
    this.id,
    this.nome,
    this.setor,
    this.sede,
    this.supervisor,
    this.isActive,
    this.createdAt,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('areas/${this.id}');

  get getId => id;
  get getNome => nome;
  get getSetor => setor;
  get getSede => sede;
  get getSupervisor => supervisor;
  get getIsActive => isActive;
  get getCreatedAt => createdAt;

  set setId(String id) => this.id = id;
  set setNome(String nome) => this.nome = nome;
  set setsetor(String setor) => this.setor = setor;
  set setSede(String sede) => this.sede = sede;
  set setSupervisor(String supervisor) => this.supervisor = supervisor;
  set setIsactive(bool isActive) => this.isActive = isActive;
  set setCreatedAt(DateTime createdAt) => this.createdAt = createdAt;

  Map<String, dynamic> toDocument() => {
        'nome': nome,
        'setor': setor,
        'sede': sede,
        'supervisor': supervisor,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  get getEmpty => empty;

  static AreasModel empty = AreasModel(
    id: '',
    nome: '',
    setor: '',
    sede: '',
    supervisor: '',
    isActive: false,
    createdAt: DateTime.now(),
  );

  factory AreasModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return AreasModel(
      id: doc.id,
      nome: data['nome'] as String,
      setor: data['setor'] as String,
      sede: data['sede'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
    );
    
  }

  static Future<AreasModel> getArea(String areaId) async {
    final doc = await FirebaseFirestore.instance.doc('areas/$areaId').get();
    return doc.exists ? AreasModel.fromDocument(doc) : AreasModel.empty;
  }

  Future<void> saveArea() async => await firestoreRef.set(toDocument());

  Future<void> updateArea(AreasModel area) async {
    return await FirebaseFirestore.instance
        .doc('areas/${area.id}')
        .update(area.toDocument());
  }
}
