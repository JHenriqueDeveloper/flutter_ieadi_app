import 'package:cloud_firestore/cloud_firestore.dart';

class CongregModel {
  String id;
  String dirigente;
  String idArea;
  String nome;
  String dataFundacao;
  String unidadeConsumidora;
  String profileImageUrl;
  //String idArea;

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

  //configurações
  bool isActive;
  DateTime createdAt;
  List tags;

  CongregModel({
    this.id,
    this.dirigente,
    this.idArea,
    this.nome,
    this.dataFundacao,
    this.unidadeConsumidora,
    this.profileImageUrl,
    this.isActive,
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
    this.createdAt,
    this.tags,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('congregs/${this.id}');

  get getId => id;
  get getDirigente => dirigente;
  get getIdArea => idArea;
  get getNome => nome;
  get getDataFundacao => dataFundacao;
  get getUnidadeConsumidora => unidadeConsumidora;
  get getProfileImageUrl => profileImageUrl;
  get getIsActive => isActive;
  get getCep => cep;
  get getLogradouro => logradouro;
  get getComplemento => complemento;
  get getBairro => bairro;
  get getCidade => cidade;
  get getUf => uf;
  get getNumero => numero;
  get getFixo => fixo;
  get getCelular => celular;
  get getEmail => email;
  get getCreatedAt => createdAt;

  set setId(String id) => this.id = id;
  set setDirigente(String dirigente) => this.dirigente = dirigente;
  set setIdArea(String idArea) => this.idArea = idArea;
  set setNome(String nome) => this.nome = nome;
  set setDataFundacao(String dataFundacao) => this.dataFundacao = dataFundacao;
  set setUnidadeConsumidora(String unidadeConsumidora) =>
      this.unidadeConsumidora = unidadeConsumidora;
  set setProfileImageUrl(String profileImageUrl) =>
      this.profileImageUrl = profileImageUrl;
  set setIsactive(bool isActive) => this.isActive = isActive;
  set setCep(String cep) => this.cep = cep;
  set setLogradouro(String logradouro) => this.logradouro = logradouro;
  set setComplemento(String complemento) => this.complemento = complemento;
  set setBairro(String bairro) => this.bairro = bairro;
  set setCidade(String cidade) => this.cidade = cidade;
  set setUf(String uf) => this.uf = uf;
  set setNumero(String numero) => this.numero = numero;
  set setFixo(String fixo) => this.fixo = fixo;
  set setCelular(String celular) => this.celular = celular;
  set setEmail(String email) => this.email = email;
  set setCreatedAt(DateTime createdAt) => this.createdAt = createdAt;

  Map<String, dynamic> toDocument() => {
        'dirigente': dirigente,
        'idArea': idArea,
        'nome': nome,
        'dataFundacao': dataFundacao,
        'unidadeConsumidora': unidadeConsumidora,
        'profileImageUrl': profileImageUrl,
        'isActive': isActive,
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
        'createdAt': Timestamp.fromDate(createdAt),
      };

  get getCongregEmpty => empty;

  static CongregModel empty = CongregModel(
    id: null,
    dirigente: null,
    idArea: null,
    nome: '',
    dataFundacao: '',
    unidadeConsumidora: '',
    profileImageUrl: '',
    isActive: true,
    cep: '',
    logradouro: '',
    complemento: '',
    bairro: '',
    cidade: '',
    uf: null,
    numero: '',
    fixo: '',
    celular: '',
    email: '',
    tags: [],
    createdAt: DateTime.now(),
  );

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

  static Future<CongregModel> getCongreg(String congregId) async {
    if (congregId != null) {
      final doc =
          await FirebaseFirestore.instance.doc('congregs/$congregId').get();
      return doc.exists ? CongregModel.fromDocument(doc) : CongregModel.empty;
    }
    return CongregModel.empty;
  }

  Future<void> saveCongreg() async => await firestoreRef.set(toDocument());

  Future<void> updateCongreg(CongregModel congreg) async {
    return await FirebaseFirestore.instance
        .doc('congregs/${congreg.id}')
        .update(congreg.toDocument());
  }
}
