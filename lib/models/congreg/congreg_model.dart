import 'package:cloud_firestore/cloud_firestore.dart';

class CongregModel {
  String id;
  String idArea;
  String nome;
  String dataFundacao;
  String unidadeConsumidora;
  String profileImageUrl;
  //String idArea;

  //Endereco
  String cep;
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

  CongregModel({
    this.id,
    this.idArea,
    this.nome,
    this.dataFundacao,
    this.unidadeConsumidora,
    this.profileImageUrl,
    this.isActive,
    this.cep,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.numero,
    this.fixo,
    this.celular,
    this.email,
    this.createdAt,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('congregs/${this.id}');

  get getId => id;
  get getIdArea => idArea;
  get getNome => nome;
  get getDataFundacao => dataFundacao;
  get getUnidadeConsumidora => unidadeConsumidora;
  get getProfileImageUrl => profileImageUrl;
  get getIsActive => isActive;
  get getCep => cep;
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
  set setIdAdea(String idArea) => this.idArea = idArea;
  set setNome(String nome) => this.nome = nome;
  set setDataFundacao(String dataFundacao) => this.dataFundacao = dataFundacao;
  set setUnidadeConsumidora(String unidadeConsumidora) =>
      this.unidadeConsumidora = unidadeConsumidora;
  set setProfileImageUrl(String profileImageUrl) =>
      this.profileImageUrl = profileImageUrl;
  set setIsactive(bool isActive) => this.isActive = isActive;
  set setCep(String cep) => this.cep = cep;
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
        'idArea': idArea,
        'nome': nome,
        'dataFundacao': dataFundacao,
        'unidadeConsumidora': unidadeConsumidora,
        'profileImageUrl': profileImageUrl,
        'isActive': isActive,
        'cep': cep,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'uf': uf,
        'numero': numero,
        'fixo': fixo,
        'celular': celular,
        'email': email,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  get getCongregEmpty => empty;

  static CongregModel empty = CongregModel(
    id: '',
    idArea: '',
    nome: '',
    dataFundacao: '',
    unidadeConsumidora: '',
    profileImageUrl: '',
    isActive: false,
    cep: '',
    complemento: '',
    bairro: '',
    cidade: '',
    uf: '',
    numero: '',
    fixo: '',
    celular: '',
    email: '',
    createdAt: DateTime.now(),
  );

  factory CongregModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return CongregModel(
      id: doc.id,
      idArea: data['idArea'] as String,
      nome: data['nome'] as String,
      dataFundacao: data['dataFundacao'] as String,
      unidadeConsumidora: data['unidadeConsumidora'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
      isActive: data['isActive'] as bool,
      cep: data['cep'] as String,
      complemento: data['complemento'] as String,
      bairro: data['bairro'] as String,
      cidade: data['cidade'] as String,
      uf: data['uf'] as String,
      numero: data['numero'] as String,
      fixo: data['fixo'] as String,
      celular: data['celular'] as String,
      email: data['email'] as String,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
    );
  }

  static Future<CongregModel> getCongreg(String congregId) async {
    final doc =
        await FirebaseFirestore.instance.doc('congregs/$congregId').get();
    return doc.exists ? CongregModel.fromDocument(doc) : CongregModel.empty;
  }

  Future<void> saveCongreg() async => await firestoreRef.set(toDocument());

  Future<void> updateCongreg(CongregModel congreg) async {
    return await FirebaseFirestore.instance
        .doc('congregs/${congreg.id}')
        .update(congreg.toDocument());
  }
}
