import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class AreasModel {
  String id;
  String nome;
  String setor;
  String sede;
  String supervisor;
  //configurações
  bool isActive;
  DateTime createdAt;
  List tags;

  AreasModel({
    this.id,
    this.nome,
    this.setor,
    this.sede,
    this.supervisor,
    this.isActive,
    this.createdAt,
    this.tags,
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
        'tags': tags,
      };

  get getEmpty => empty;

  static AreasModel empty = AreasModel(
    id: null,
    nome: '',
    setor: null,
    sede: null,
    supervisor: null,
    isActive: true,
    createdAt: DateTime.now(),
    tags: [],
  );

  factory AreasModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc == null) return null;
    final Map<String, dynamic> data = doc.data();
    return AreasModel(
      id: doc.id,
      nome: data['nome'] as String,
      setor: data['setor'] as String,
      sede: data['sede'] as String,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
    );
  }

  List get getTags => [
    this.id,
    this.isActive ? 'ativo' : 'inativo',
    this.nome != null ? this.nome.toLowerCase() : '',
    this.setor,
    this.sede,
    this.supervisor,
    '*',
  ];

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

  static Future<List<AreasModel>> searchTags({
    @required String value,
  }) async {
    if (value != '') {
      final result = await FirebaseFirestore.instance
          .collection('areas')
          .where('tags', arrayContains: value.toLowerCase())
          .get();

      final list =
          result.docs.map((doc) => AreasModel.fromDocument(doc)).toList();
      return list;
    }
    return [];
  }
}
