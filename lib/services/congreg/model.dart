import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';

class CongregModel extends BaseModel {
  String id;
  bool isActive;
  DateTime createdAt;
  String dirigente;
  String idArea;
  String nome;
  String dataFundacao;
  String unidadeConsumidora;
  String profileImageUrl;
  //Endereco
  String cep;
  String logradouro;
  String complemento;
  String bairro;
  String cidade;
  String uf;
  String numero;
  //Contatos
  String fixo;
  String celular;
  String email;
  List tags;

  CongregModel({
    this.id,
    this.isActive,
    this.createdAt,
    this.dirigente,
    this.idArea,
    this.nome,
    this.dataFundacao,
    this.unidadeConsumidora,
    this.profileImageUrl,
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.numero,
    this.fixo,
    this.celular,
    this.email,
    this.tags,
  });

  @override
  String get getCollection => 'congregs';

  @override
  List get getTags => [
        this.id,
        this.dirigente,
        this.idArea,
        this.isActive ? 'ativo' : 'inativo',
        this.nome.toLowerCase(),
        this.dataFundacao,
        this.unidadeConsumidora,
        this.cep,
        this.logradouro.toLowerCase(),
        this.bairro.toLowerCase(),
        this.cidade.toLowerCase(),
        this.uf.toLowerCase(),
        this.numero.toLowerCase(),
        this.fixo,
        this.celular,
        this.email.toLowerCase(),
      ];
  
  @override
  get getEmpty => empty;

  static CongregModel empty = CongregModel(
    id: null,
    isActive: true,
    createdAt: DateTime.now(),
    dirigente: null,
    idArea: null,
    nome: null,
    dataFundacao: null,
    unidadeConsumidora: null,
    profileImageUrl: null,
    cep: null,
    logradouro: null,
    complemento: null,
    bairro: null,
    cidade: null,
    uf: null,
    numero: null,
    fixo: null,
    celular: null,
    email: null,
    tags: [],
  );

  @override
  Map<String, dynamic> toDocument() => {
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'dirigente': dirigente,
        'idArea': idArea,
        'nome': nome,
        'dataFundacao': dataFundacao,
        'unidadeConsumidora': unidadeConsumidora,
        'profileImageUrl': profileImageUrl,
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'uf': uf,
        'numero': numero,
        'fixo': fixo,
        'celular': celular,
        'email': email,
        'tags': tags,
      };

  factory CongregModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return CongregModel(
      id: doc.id,
      dirigente: data['dirigente'] as String,
      idArea: data['idArea'] as String,
      nome: data['nome'] as String,
      dataFundacao: data['dataFundacao'] as String,
      unidadeConsumidora: data['unidadeConsumidora'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
      isActive: data['isActive'] as bool,
      cep: data['cep'] as String,
      logradouro: data['logradouro'] as String,
      complemento: data['complemento'] as String,
      bairro: data['bairro'] as String,
      cidade: data['cidade'] as String,
      uf: data['uf'] as String,
      numero: data['numero'] as String,
      fixo: data['fixo'] as String,
      celular: data['celular'] as String,
      email: data['email'] as String,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
    );
  }
}
