import 'package:cloud_firestore/cloud_firestore.dart';

class CongregModel {
  String id;
  String nome;
  String dataFundacao;
  String unidadeConsumidora;
  String profileImageUrl;
  //String idArea;
  bool isSedeCampo;
  bool isSedeSetor;
  bool isSedeArea;
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

  CongregModel({
    this.id,
    this.nome,
    this.dataFundacao,
    this.unidadeConsumidora,
    this.profileImageUrl,
    this.isSedeCampo,
    this.isSedeSetor,
    this.isSedeArea,
    this.cep,
    this.complemento,
    this.bairro,
    this.cidade,
    this.uf,
    this.numero,
    this.fixo,
    this.celular,
    this.email,
  });

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('congregs/${this.id}');

  get getId => id;
  get getNome => nome;
  get getDataFundacao => dataFundacao;
  get getUnidadeConsumidora => unidadeConsumidora;
  get getProfileImageUrl => profileImageUrl;
  get getIsSedeCampo => isSedeCampo;
  get getIsSedeArea => isSedeArea;
  get getIsSedeSetor => isSedeSetor;
  get getCep => cep;
  get getComplemento => complemento;
  get getBairro => bairro;
  get getCidade => cidade;
  get getUf => uf;
  get getNumero => numero;
  get getFixo => fixo;
  get getCelular => celular;
  get getEmail => email;

  set setId(String id) => this.id = id;
  set setNome(String nome) => this.nome = nome;
  set setDataFundacao(String dataFundacao) => this.dataFundacao = dataFundacao;
  set setUnidadeConsumidora(String unidadeConsumidora) =>
      this.unidadeConsumidora = unidadeConsumidora;
  set setProfileImageUrl(String profileImageUrl) =>
      this.profileImageUrl = profileImageUrl;
  set setIsSedeCampo(bool isSedeCampo) => this.isSedeCampo = isSedeCampo;
  set setIsSedeArea(bool isSedeArea) => this.isSedeArea = isSedeArea;
  set setIsSedeSetor(bool isSedeSetor) => this.isSedeSetor = isSedeSetor;
  set setCep(String cep) => this.cep = cep;
  set setComplemento(String complemento) => this.complemento = complemento;
  set setBairro(String bairro) => this.bairro = bairro;
  set setCidade(String cidade) => this.cidade = cidade;
  set setUf(String uf) => this.uf = uf;
  set setNumero(String numero) => this.numero = numero;
  set setFixo(String fixo) => this.fixo = fixo;
  set setCelular(String celular) => this.celular = celular;
  set setEmail(String email) => this.email = email;

  Map<String, dynamic> toDocument() => {
        'nome': nome,
        'dataFundacao': dataFundacao,
        'unidadeConsumidora': unidadeConsumidora,
        'profileImageUrl': profileImageUrl,
        'isSedeCampo': isSedeCampo,
        'isSedeSetor': isSedeSetor,
        'isSedeArea': isSedeArea,
        'cep': cep,
        'complemento': complemento,
        'bairro': bairro,
        'cidade': cidade,
        'uf': uf,
        'numero': numero,
        'fixo': fixo,
        'celular': celular,
        'email': email,
      };

  get getCongregEmpty => empty;

  static CongregModel empty = CongregModel(
    id: '',
    nome: '',
    dataFundacao: '',
    unidadeConsumidora: '',
    profileImageUrl: '',
    isSedeCampo: false,
    isSedeSetor: false,
    isSedeArea: false,
    cep: '',
    complemento: '',
    bairro: '',
    cidade: '',
    uf: '',
    numero: '',
    fixo: '',
    celular: '',
    email: '',
  );

  factory CongregModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return CongregModel(
      id: doc.id,
      nome: data['nome'] as String,
      dataFundacao: data['dataFundacao'] as String,
      unidadeConsumidora: data['unidadeConsumidora'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
      isSedeCampo: data['isSedeCampo'] as bool,
      isSedeSetor: data['isSedeSetor'] as bool,
      isSedeArea: data['isSedeArea'] as bool,
      cep: data['cep'] as String,
      complemento: data['complemento'] as String,
      bairro: data['bairro'] as String,
      cidade: data['cidade'] as String,
      uf: data['uf'] as String,
      numero: data['numero'] as String,
      fixo: data['fixo'] as String,
      celular: data['celular'] as String,
      email: data['email'] as String,
    );
    /*
    CongregModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      dataFundacao: data['dataFundacao'] ?? '',
      unidadeConsumidora: data['unidadeConsumidora'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      isSedeCampo: data['isSedeCampo'] ?? false,
      isSedeSetor: data['isSedeSetor'] ?? false,
      isSedeArea: data['isSedeArea'] ?? false,
      cep: data['cep'] ?? '',
      complemento: data['complemento'] ?? '',
      bairro: data['bairro'] ?? '',
      cidade: data['cidade'] ?? '',
      uf: data['uf'] ?? '',
      numero: data['numero'] ?? '',
      fixo: data['fixo'] ?? '',
      celular: data['celular'] ?? '',
      email: data['email'] ?? '',
    );
    */
  }

  static Future<CongregModel> getUser(String congregId) async {
    final doc =
        await FirebaseFirestore.instance.doc('congregs/$congregId').get();
    return doc.exists ? CongregModel.fromDocument(doc) : CongregModel.empty;
  }

  Future<void> saveUser() async => await firestoreRef.set(toDocument());

  Future<void> updateUser(CongregModel congreg) async {
    return await FirebaseFirestore.instance
        .doc('congregs/${congreg.id}')
        .update(congreg.toDocument());
  }
}
