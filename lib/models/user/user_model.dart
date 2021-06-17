import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  //Conta
  String id;
  String username;
  String email;
  String password;
  String confirmPassword; //para confirmar no cadastro

  UserModel({
    this.id,
    this.username,
    this.email,
    this.password,
  });

  get getId => id;
  get getUsername => username;
  get getEmail => email;
  get getPassword => password;
  get getConfirmPassword => confirmPassword;

  set setId(String id) => this.id = id;
  set setUsername(String username) => this.username = username;
  set setEmail(String email) => this.email = email;
  set setPassword(String password) => this.password = password;
  set setConfirmPassword(String confirmPassword) =>
      this.confirmPassword = confirmPassword;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/${this.id}');

  Map<String, dynamic> toDocument() => {
        'username': username,
        'email': email,
      };

  static UserModel empty = UserModel(
    id: '',
    username: '',
    email: '',
  );

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Future<void> saveUser() async => await firestoreRef.set(toDocument());

  static Future<UserModel> getUser(String userId) async {
    final doc = await FirebaseFirestore.instance.doc('users/$userId').get();
    return doc.exists 
    ? UserModel.fromDocument(doc) 
    : UserModel.empty;
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  //Conta
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  //Dados civis
  final String nome;
  final String cpf;
  final String rg;
  final String naturalidade;
  final String nomePai;
  final String nomeMae;
  final String dataNascimento;
  final String estadoCivil;
  final String genero;
  final String tipoSanguineo;
  //Dados eleitorais
  final String tituloEleitor;
  final String zonaEleitor;
  final String secaoEleitor;
  //Necessidades especiais
  final String tipoNecessidade;
  final String descricaoNecessidade;
  //Endereco
  final String cep;
  final String uf;
  final String cidade;
  final String bairro;
  final String logradouro;
  final String complemento;
  final String numero;
  //Contatos
  final String numeroFixo;
  final String numeroCelular;
  //Perfil Cristão
  final String congregacao;
  final String tipoMembro;
  final String situacaoMembro;
  final String procedenciaMembro;
  final String origemMembro;
  final String dataMudanca;
  final String dataConversao;
  final String localConversao;
  final String dataBatismoAguas;
  final String localBatismoAguas;
  final String dataBatismoEspiritoSanto;
  final String localBatismoEspiritoSanto;
  final bool isDizimista;
  final String bio; //biografia do membro
  //Registro de membros
  final String dataRegistro;
  final String numeroRegistro;
  final String livroRegistro;
  final String paginaRegistro;

  const User({
    //Conta
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.profileImageUrl,
    //Informações pessoais
    this.nome,
    this.cpf,
    this.rg,
    this.naturalidade,
    this.nomePai,
    this.nomeMae,
    this.dataNascimento,
    this.estadoCivil,
    this.genero,
    this.tipoSanguineo,
    //Dados eleitorais
    this.tituloEleitor,
    this.zonaEleitor,
    this.secaoEleitor,
    //Necessidades especiais
    this.tipoNecessidade,
    this.descricaoNecessidade,
    //Endereco
    this.cep,
    this.uf,
    this.cidade,
    this.bairro,
    this.logradouro,
    this.complemento,
    this.numero,
    //Contatos
    this.numeroFixo,
    this.numeroCelular,
    //Perfil Cristão
    this.congregacao,
    this.tipoMembro,
    this.situacaoMembro,
    this.procedenciaMembro,
    this.origemMembro,
    this.dataMudanca,
    this.dataConversao,
    this.localConversao,
    this.dataBatismoAguas,
    this.localBatismoAguas,
    this.dataBatismoEspiritoSanto,
    this.localBatismoEspiritoSanto,
    this.isDizimista,
    this.bio, //biografia do membro
    //Registro de membros
    this.dataRegistro,
    this.numeroRegistro,
    this.livroRegistro,
    this.paginaRegistro,
  });

  static const empty = User(
    id: '',
    username: '',
    email: '',
    profileImageUrl: '',
    //Dados civis
    nome: '',
    cpf: '',
    rg: '',
    naturalidade: '',
    nomePai: '',
    nomeMae: '',
    dataNascimento: '',
    estadoCivil: '',
    genero: '',
    tipoSanguineo: '',
    //Dados eleitorais
    tituloEleitor: '',
    zonaEleitor: '',
    secaoEleitor: '',
    //Necessidades especiais
    tipoNecessidade: '',
    descricaoNecessidade: '',
    //Endereco
    cep: '',
    uf: '',
    cidade: '',
    bairro: '',
    logradouro: '',
    complemento: '',
    numero: '',
    //Contatos
    numeroFixo: '',
    numeroCelular: '',
    //Perfil Cristão
    congregacao: '',
    tipoMembro: '',
    situacaoMembro: '',
    procedenciaMembro: '',
    origemMembro: '',
    dataMudanca: '',
    dataConversao: '',
    localConversao: '',
    dataBatismoAguas: '',
    localBatismoAguas: '',
    dataBatismoEspiritoSanto: '',
    localBatismoEspiritoSanto: '',
    isDizimista: false,
    bio: '', //biografia do membro
    //Registro de membros
    dataRegistro: '',
    numeroRegistro: '',
    livroRegistro: '',
    paginaRegistro: '',
  );

  @override
  List<Object> get props => [
    id,
    username,
    email,
    profileImageUrl,
    //Dados civis
    nome,
    cpf,
    rg,
    naturalidade,
    nomePai,
    nomeMae,
    dataNascimento,
    estadoCivil,
    genero,
    tipoSanguineo,
    //Dados eleitorais
    tituloEleitor,
    zonaEleitor,
    secaoEleitor,
    //Necessidades especiais
    tipoNecessidade,
    descricaoNecessidade,
    //Endereco
    cep,
    uf,
    cidade,
    bairro,
    logradouro,
    complemento,
    numero,
    //Contatos
    numeroFixo,
    numeroCelular,
    //Perfil Cristão
    congregacao,
    tipoMembro,
    situacaoMembro,
    procedenciaMembro,
    origemMembro,
    dataMudanca,
    dataConversao,
    localConversao,
    dataBatismoAguas,
    localBatismoAguas,
    dataBatismoEspiritoSanto,
    localBatismoEspiritoSanto,
    isDizimista,
    bio,//biografia do membro
    //Registro de membros
    dataRegistro,
    numeroRegistro,
    livroRegistro,
    paginaRegistro,
  ];

  User copyWith({
    String id,
    String username,
    String email,
    String profileImageUrl,
    //Dados Civis
    String nome,
    String cpf,
    String rg,
    String naturalidade,
    String nomePai,
    String nomeMae,
    String dataNascimento,
    String estadoCivil,
    String genero,
    String tipoSanguineo,
    //Dados eleitorais
    String tituloEleitor,
    String zonaEleitor,
    String secaoEleitor,
    //Necessidades especiais
    String tipoNecessidade,
    String descricaoNecessidade,
    //Endereco
    String cep,
    String uf,
    String cidade,
    String bairro,
    String logradouro,
    String complemento,
    String numero,
    //Contatos
    String numeroFixo,
    String numeroCelular,
    //Perfil Cristão
    String congregacao,
    String tipoMembro,
    String situacaoMembro,
    String procedenciaMembro,
    String origemMembro,
    String dataMudanca,
    String dataConversao,
    String localConversao,
    String dataBatismoAguas,
    String localBatismoAguas,
    String dataBatismoEspiritoSanto,
    String localBatismoEspiritoSanto,
    bool isDizimista,
    String bio, //biografia do membro
    //Registro de membros
    String dataRegistro,
    String numeroRegistro,
    String livroRegistro,
    String paginaRegistro,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      //Dados Civis
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      rg: rg ?? this.rg,
      naturalidade: naturalidade ?? this.naturalidade,
      nomePai: nomePai ?? this.nomePai,
      nomeMae: nomeMae ?? this.nomeMae,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      genero: genero ?? this.genero,
      tipoSanguineo: tipoSanguineo ?? this.tipoSanguineo,
      //Dados eleitorais
      tituloEleitor: tituloEleitor ?? this.tituloEleitor,
      zonaEleitor: zonaEleitor ?? this.zonaEleitor,
      secaoEleitor: secaoEleitor ?? this.secaoEleitor,
      //Necessidades especiais
      tipoNecessidade: tipoNecessidade ?? this.tipoNecessidade,
      descricaoNecessidade: descricaoNecessidade ?? this.descricaoNecessidade,
      //Endereco
      cep: cep ?? this.cep,
      uf: uf ?? this.uf,
      cidade: cidade ?? this.cidade,
      bairro: bairro ?? this.bairro,
      logradouro: logradouro ?? this.logradouro,
      complemento: complemento ?? this.complemento,
      numero: numero ?? this.numero,
      //Contatos
      numeroFixo: numeroFixo ?? this.numeroFixo,
      numeroCelular: numeroCelular ?? this.numeroCelular,
      //Perfil Cristão
      congregacao: congregacao ?? this.congregacao,
      tipoMembro: tipoMembro ?? this.tipoMembro,
      situacaoMembro: situacaoMembro ?? this.situacaoMembro,
      procedenciaMembro: procedenciaMembro ?? this.procedenciaMembro,
      origemMembro: origemMembro ?? this.origemMembro,
      dataMudanca: dataMudanca ?? this.dataMudanca,
      dataConversao: dataConversao ?? this.dataConversao,
      localConversao: localConversao ?? this.localConversao,
      dataBatismoAguas: dataBatismoAguas ?? this.dataBatismoAguas,
      localBatismoAguas: localBatismoAguas ?? this.localBatismoAguas,
      dataBatismoEspiritoSanto: dataBatismoEspiritoSanto ?? this.dataBatismoEspiritoSanto,
      localBatismoEspiritoSanto: localBatismoEspiritoSanto ?? this.localBatismoEspiritoSanto,
      isDizimista: isDizimista ?? this.isDizimista,
      bio: bio ?? this.bio, //biografia do membro
      //Registro de membros
      dataRegistro: dataRegistro ?? this.dataRegistro,
      numeroRegistro: numeroRegistro ?? this.numeroRegistro,
      livroRegistro: livroRegistro ?? this.livroRegistro,
      paginaRegistro: paginaRegistro ?? this.paginaRegistro,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'username': username,
      'email': email,
      'profileImageUrl': profileImageUrl,
      //Dados Civis
      'nome': nome,
      'cpf': cpf,
      'rg': rg,
      'naturalidade': naturalidade,
      'nomePai': nomePai,
      'nomeMae': nomeMae,
      'dataNascimento': dataNascimento,
      'estadoCivil': estadoCivil,
      'genero': genero,
      'tipoSanguineo': tipoSanguineo,
      //Dados eleitorais
      'tituloEleitor': tituloEleitor,
      'zonaEleitor': zonaEleitor,
      'secaoEleitor': secaoEleitor,
      //Necessidades especiais
      'tipoNecessidade': tipoNecessidade,
      'descricaoNecessidade': descricaoNecessidade,
      //Endereco
      'cep': cep,
      'uf': uf,
      'cidade': cidade,
      'bairro': bairro,
      'logradouro': logradouro,
      'complemento': complemento,
      'numero': numero,
      //Contatos
      'numeroFixo': numeroFixo,
      'numeroCelular': numeroCelular,
      //Perfil Cristão
      'congregacao': congregacao,
      'tipoMembro': tipoMembro,
      'situacaoMembro': situacaoMembro,
      'procedenciaMembro': procedenciaMembro,
      'origemMembro': origemMembro,
      'dataMudanca': dataMudanca,
      'dataConversao': dataConversao,
      'localConversao': localConversao,
      'dataBatismoAguas': dataBatismoAguas,
      'localBatismoAguas': localBatismoAguas,
      'dataBatismoEspiritoSanto': dataBatismoEspiritoSanto,
      'localBatismoEspiritoSanto': localBatismoEspiritoSanto,
      'isDizimista': isDizimista,
      'bio': bio, //biografia do membro
      //Registro de membros
      'dataRegistro': dataRegistro,
      'numeroRegistro': numeroRegistro,
      'livroRegistro': livroRegistro,
      'paginaRegistro': paginaRegistro,
    };
  }

  factory User.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return User(
      id: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      //Dados Civis
      nome: data['nome'] ?? '',
      cpf: data['cpf'] ?? '',
      rg: data['rg'] ?? '',
      naturalidade: data['naturalidade'] ?? '',
      nomePai: data['nomePai'] ?? '',
      nomeMae: data['nomeMae'] ?? '',
      dataNascimento: data['dataNascimento'] ?? '',
      estadoCivil: data['estadoCivil'] ?? '',
      genero: data['genero'] ?? '',
      tipoSanguineo: data['tipoSanguineo'] ?? '',
      //Dados eleitorais
      tituloEleitor: data['tituloEleitor'] ?? '',
      zonaEleitor: data['zonaEleitor'] ?? '',
      secaoEleitor: data['secaoEleitor'] ?? '',
      //Necessidades especiais
      tipoNecessidade: data['tipoNecessidade'] ?? '',
      descricaoNecessidade: data['descricaoNecessidade'] ?? '',
      //Endereco
      cep: data['cep'] ?? '',
      uf: data['uf'] ?? '',
      cidade: data['cidade'] ?? '',
      bairro: data['bairro'] ?? '',
      logradouro: data['logradouro'] ?? '',
      complemento: data['complemento'] ?? '',
      numero: data['numero'] ?? '',
      //Contatos
      numeroFixo: data['numeroFixo'] ?? '',
      numeroCelular: data['numeroCelular'] ?? '',
      //Perfil Cristão
      congregacao: data['congregacao'] ?? '',
      tipoMembro: data['tipoMembro'] ?? '',
      situacaoMembro: data['situacaoMembro'] ?? '',
      procedenciaMembro: data['procedenciaMembro'] ?? '',
      origemMembro: data['origemMembro'] ?? '',
      dataMudanca: data['dataMudanca'] ?? '',
      dataConversao: data['dataConversao'] ?? '',
      localConversao: data['localConversao'] ?? '',
      dataBatismoAguas: data['dataBatismoAguas'] ?? '',
      localBatismoAguas: data['localBatismoAguas'] ?? '',
      dataBatismoEspiritoSanto: data['dataBatismoEspiritoSanto'] ?? '',
      localBatismoEspiritoSanto: data['localBatismoEspiritoSanto'] ?? '',
      isDizimista: data['isDizimista'] ?? '',
      bio: data['bio'] ?? '', //biografia do membro
      //Registro de membros
      dataRegistro: data['dataRegistro'] ?? '',
      numeroRegistro: data['numeroRegistro'] ?? '',
      livroRegistro: data['livroRegistro'] ?? '',
      paginaRegistro: data['paginaRegistro'] ?? '',
    );
  }
}

*/
