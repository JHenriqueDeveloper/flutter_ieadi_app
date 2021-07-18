import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';

class MinisterioModel extends BaseModel {
  String id;
  bool isActive;
  DateTime createdAt;
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
    this.isActive,
    this.createdAt,
    this.profileImageUrl,
    this.sigla,
    this.nome,
    this.cnpj,
    this.fundacao,
    this.telefoneFixo,
    this.telefoneCelular,
    this.sede,
    this.presidente,
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

  @override
  String get getCollection => 'ministerio';

  @override
  List get getTags => [];

  @override
  get getEmpty => empty;
  
  static MinisterioModel empty = MinisterioModel(
    id: null,
    isActive: true,
    createdAt: DateTime.now(),
    profileImageUrl: null,
    sigla: null,
    nome: null,
    cnpj: null,
    fundacao: null,
    telefoneFixo: null,
    telefoneCelular: null,
    sede: null,
    presidente: null,
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

  @override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'profileImageUrl': profileImageUrl,
        'sigla': sigla,
        'nome': nome,
        'cnpj': cnpj,
        'fundacao': fundacao,
        'telefoneFixo': telefoneFixo,
        'telefoneCelular': telefoneCelular,
        'sede': sede,
        'presidente': presidente,
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

  factory MinisterioModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return MinisterioModel(
      id: doc.id,
      nome: data['nome'] as String,
      sede: data['sede'] as String,
      sigla: data['sigla'] as String,
      isActive: data['isActive'] as bool,
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
