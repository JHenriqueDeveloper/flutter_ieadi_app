import 'package:cloud_firestore/cloud_firestore.dart';

class MinisterioModel {
  String id;
  String profileImageUrl;
  String sigla;
  String nome;
  String cnpj;
  String fundacao;
  String telefoneFixo;
  String telefoneCelular;
  String sede;
  String presidente;
  String vicePresidente;
  String presidenteEtica;
  String presidenteFiscal;

  DateTime createdAt;

  List tesoureiros;
  List secretarios;
  List fiscal; //conselho fiscal
  List etica; //conselho de etica
  List departamentos;
  List pastores;
  List evanConsagrados;
  List evanAutorizados;
  List evanLocais;
  List presbiteros;
  List diaconos;
  List auxiliares;
  List obreiros;

  MinisterioModel({
    this.id,
    this.profileImageUrl,
    this.sigla,
    this.nome,
    this.cnpj,
    this.fundacao,
    this.telefoneFixo,
    this.telefoneCelular,
    this.sede,
    this.presidente,
    this.createdAt,
    this.departamentos,
    this.pastores,
    this.evanConsagrados,
    this.evanAutorizados,
    this.evanLocais,
    this.presbiteros,
    this.diaconos,
    this.auxiliares,
    this.obreiros,
    this.vicePresidente,
    this.presidenteEtica,
    this.presidenteFiscal,
    this.tesoureiros,
    this.secretarios,
    this.fiscal,
    this.etica,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('ministerio/${this.id}');

  get getEmpty => empty;

  static MinisterioModel empty = MinisterioModel(
    id: null,
    profileImageUrl: '',
    sigla: '',
    nome: '',
    cnpj: '',
    fundacao: '',
    telefoneFixo: '',
    telefoneCelular: '',
    sede: null,
    presidente: null,
    createdAt: DateTime.now(),
    departamentos: [],
    pastores: [],
    evanConsagrados: [],
    evanAutorizados: [],
    evanLocais: [],
    presbiteros: [],
    diaconos: [],
    auxiliares: [],
    obreiros: [],
    vicePresidente: null,
    presidenteEtica: null,
    presidenteFiscal: null,
    tesoureiros: [],
    secretarios: [],
    fiscal: [],
    etica: [],
  );

  Map<String, dynamic> toDocument() => {
        'profileImageUrl': profileImageUrl,
        'sigla': sigla,
        'nome': nome,
        'cnpj': cnpj,
        'fundacao': fundacao,
        'telefoneFixo': telefoneFixo,
        'telefoneCelular': telefoneCelular,
        'sede': sede,
        'presidente': presidente,
        'createdAt': Timestamp.fromDate(createdAt),
        'departamentos': departamentos,
        'pastores': pastores,
        'evanConsagrados': evanConsagrados,
        'evanAutorizados': evanAutorizados,
        'evanLocais': evanLocais,
        'presbiteros': presbiteros,
        'diaconos': diaconos,
        'auxiliares': auxiliares,
        'obreiros': obreiros,
        'vicePresidente': vicePresidente,
        'presidenteEtica': presidenteEtica,
        'presidenteFiscal': presidenteFiscal,
        'tesoureiros': tesoureiros,
        'secretarios': secretarios,
        'fiscal': fiscal,
        'etica': etica,
      };

  factory MinisterioModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    if (doc == null) return null;
    final Map<String, dynamic> data = doc.data();
    return MinisterioModel(
      id: doc.id,
      nome: data['nome'] as String,
      sede: data['sede'] as String,
      sigla: data['sigla'] as String,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      profileImageUrl: data['profileImageUrl'] as String,
      cnpj: data['cnpj'] as String,
      fundacao: data['fundacao'] as String,
      telefoneFixo: data['telefoneFixo'] as String,
      telefoneCelular: data['telefoneCelular'] as String,
      presidente: data['presidente'] as String,
      departamentos: data['departamentos'] as List,
      pastores: data['pastores'] as List,
      evanConsagrados: data['evanConsagrados'] as List,
      evanAutorizados: data['evanAutorizados'] as List,
      evanLocais: data['evanLocais'] as List,
      presbiteros: data['presbiteros'] as List,
      diaconos: data['diaconos'] as List,
      auxiliares: data['auxiliares'] as List,
      obreiros: data['obreiros'] as List,
      vicePresidente: data['vicePresidente'] as String,
      presidenteEtica: data['presidenteEtica'] as String,
      presidenteFiscal: data['presidenteFiscal'] as String,
      tesoureiros: data['tesoureiros'] as List,
      secretarios: data['secretarios'] as List,
      fiscal: data['fiscal'] as List,
      etica: data['etica'] as List,
    );
  }
}

/*

  

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

*/
