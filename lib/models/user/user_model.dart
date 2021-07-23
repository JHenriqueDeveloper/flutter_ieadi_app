import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class UserModel {
  //Conta
  String id;
  String username;
  String matricula;
  String email;
  String password;
  String confirmPassword; //para confirmar no cadastro
  String profileImageUrl;
  //Dados civis
  String cpf;
  String rg;
  String naturalidade;
  String nomePai;
  String nomeMae;
  String dataNascimento;
  String estadoCivil;
  String genero;
  String tipoSanguineo;
  //Dados eleitorais
  String tituloEleitor;
  String zonaEleitor;
  String secaoEleitor;
  //Necessidades especiais
  bool isPortadorNecessidade;
  String tipoNecessidade;
  String descricaoNecessidade;
  //Endereco
  String cep;
  String uf;
  String cidade;
  String bairro;
  String logradouro;
  String complemento;
  String numero;
  //Contatos
  String numeroFixo;
  String numeroCelular;
  //Perfil Cristão
  String congregacao;
  String tipoMembro;
  String situacaoMembro;
  String procedenciaMembro;
  String origemMembro;
  String dataMudanca;
  String dataConversao;
  String localConversao;
  String dataBatismoAguas;
  String localBatismoAguas;
  String dataBatismoEspiritoSanto;
  String localBatismoEspiritoSanto;
  bool isDizimista;
  String bio; //biografia do membro
  //curriculo
  bool isProcurandoOportunidades;
  String profissao;
  String pretensaoSalarial;
  String objetivos;
  String bioProfissional;
  //Registro de membros
  String dataRegistro;
  String numeroRegistro;
  String livroRegistro;
  String paginaRegistro;
  //configurações de conta
  bool isAdmin; //
  bool isMemberCard; //já possui cartão de membro
  bool isVerified; //conta verificada
  bool isActive;
  bool isVerificacaoSolicitada;

  List tags;

  DateTime createdAt;

  UserModel({
    this.id,
    this.username,
    this.matricula,
    this.email,
    this.password,
    this.profileImageUrl,
    //Informações pessoais
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
    this.isPortadorNecessidade,
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
    //curriculo
    this.isProcurandoOportunidades,
    this.profissao,
    this.pretensaoSalarial,
    this.objetivos,
    this.bioProfissional,
    //Registro de membros
    this.dataRegistro,
    this.numeroRegistro,
    this.livroRegistro,
    this.paginaRegistro,
    //configurações de conta
    this.isAdmin,
    this.isMemberCard,
    this.isVerified,
    this.isActive,
    this.createdAt,
    this.tags,
    this.isVerificacaoSolicitada,
  });

  get getId => id;
  get getUsername => username;
  get getMatricula => matricula;
  get getCpf => cpf;
  get getEmail => email;
  get getPassword => password;
  get getConfirmPassword => confirmPassword;
  get getIsAdmim => isAdmin;
  get getIsMemberCard => isMemberCard;
  get getIsVerified => isVerified;

  get getUserEmpty => empty;

  set setId(String id) => this.id = id;
  set setUsername(String username) => this.username = username;
  set setMatricula(String matricula) => this.matricula = matricula;
  set setCpf(String cpf) => this.cpf = cpf;
  set setEmail(String email) => this.email = email;
  set setPassword(String password) => this.password = password;
  set setConfirmPassword(String confirmPassword) =>
      this.confirmPassword = confirmPassword;
  set setIsAdmin(bool isAdmin) => this.isAdmin = isAdmin;
  set setIsMemberCard(bool isMemberCard) => this.isMemberCard = isMemberCard;
  set setIsVerified(bool isVerified) => this.isVerified = isVerified;

  bool _isSelected = false;
  bool get getIsSelected => _isSelected;
  set setIsSelected(bool isSelected) => this._isSelected = isSelected;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.doc('users/${this.id}');

  Map<String, dynamic> toDocument() => {
        'username': username,
        'matricula': matricula,
        'email': email,
        'profileImageUrl': profileImageUrl,
        //dados civis
        'rg': rg,
        'cpf': cpf,
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
        'isPortadorNecessidade': isPortadorNecessidade,
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
        //curriculo
        'isProcurandoOportunidades': isProcurandoOportunidades,
        'profissao': profissao,
        'pretensaoSalarial': pretensaoSalarial,
        'objetivos': objetivos,
        'bioProfissional': bioProfissional,
        //Registro de membros
        'dataRegistro': dataRegistro,
        'numeroRegistro': numeroRegistro,
        'livroRegistro': livroRegistro,
        'paginaRegistro': paginaRegistro,
        'isAdmin': isAdmin,
        'isMemberCard': isMemberCard,
        'isVerified': isVerified,
        'isActive': isActive,
        'createdAt': Timestamp.fromDate(createdAt),
        'tags': tags,
        'isVerificacaoSolicitada': isVerificacaoSolicitada,
      };

  String _collection = 'users';
  String get getCollection => _collection;

  static UserModel empty = UserModel(
    id: null,
    username: '',
    matricula: null,
    email: '',
    profileImageUrl: '',
    //Dados civis
    cpf: '',
    rg: '',
    naturalidade: '',
    nomePai: '',
    nomeMae: '',
    dataNascimento: '',
    estadoCivil: null,
    genero: null,
    tipoSanguineo: null,
    //Dados eleitorais
    tituloEleitor: '',
    zonaEleitor: '',
    secaoEleitor: '',
    //Necessidades especiais
    isPortadorNecessidade: false,
    tipoNecessidade: null,
    descricaoNecessidade: '',
    //Endereco
    cep: '',
    uf: null,
    cidade: '',
    bairro: '',
    logradouro: '',
    complemento: '',
    numero: '',
    //Contatos
    numeroFixo: '',
    numeroCelular: '',
    //Perfil Cristão
    congregacao: null,
    tipoMembro: null,
    situacaoMembro: null,
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
    //curriculo
    isProcurandoOportunidades: false,
    profissao: '',
    pretensaoSalarial: '',
    objetivos: '',
    bioProfissional: '',
    //Registro de membros
    dataRegistro: '',
    numeroRegistro: '',
    livroRegistro: '',
    paginaRegistro: '',
    //configurações da conta
    isAdmin: false,
    isMemberCard: false,
    isVerified: false,
    isActive: true,
    createdAt: DateTime.now(),
    tags: [],
    isVerificacaoSolicitada: false,
  );

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return UserModel(
      id: doc.id,
      username: data['username'] as String,
      matricula: data['matricula'] as String,
      email: data['email'] as String,
      profileImageUrl: data['profileImageUrl'] as String,
      //Dados Civis
      cpf: data['cpf'] as String,
      rg: data['rg'] as String,
      naturalidade: data['naturalidade'] as String,
      nomePai: data['nomePai'] as String,
      nomeMae: data['nomeMae'] as String,
      dataNascimento: data['dataNascimento'] as String,
      estadoCivil: data['estadoCivil'] as String,
      genero: data['genero'] as String,
      tipoSanguineo: data['tipoSanguineo'] as String,
      //Dados eleitorais
      tituloEleitor: data['tituloEleitor'] as String,
      zonaEleitor: data['zonaEleitor'] as String,
      secaoEleitor: data['secaoEleitor'] as String,
      //Necessidades especiais
      isPortadorNecessidade: data['isPortadorNecessidade'] as bool,
      tipoNecessidade: data['tipoNecessidade'] as String,
      descricaoNecessidade: data['descricaoNecessidade'] as String,
      //Endereco
      cep: data['cep'] as String,
      uf: data['uf'] as String,
      cidade: data['cidade'] as String,
      bairro: data['bairro'] as String,
      logradouro: data['logradouro'] as String,
      complemento: data['complemento'] as String,
      numero: data['numero'] as String,
      //Contatos
      numeroFixo: data['numeroFixo'] as String,
      numeroCelular: data['numeroCelular'] as String,
      //Perfil Cristão
      congregacao: data['congregacao'] as String,
      tipoMembro: data['tipoMembro'] as String,
      situacaoMembro: data['situacaoMembro'] as String,
      procedenciaMembro: data['procedenciaMembro'] as String,
      origemMembro: data['origemMembro'] as String,
      dataMudanca: data['dataMudanca'] as String,
      dataConversao: data['dataConversao'] as String,
      localConversao: data['localConversao'] as String,
      dataBatismoAguas: data['dataBatismoAguas'] as String,
      localBatismoAguas: data['localBatismoAguas'] as String,
      dataBatismoEspiritoSanto: data['dataBatismoEspiritoSanto'] as String,
      localBatismoEspiritoSanto: data['localBatismoEspiritoSanto'] as String,
      isDizimista: data['isDizimista'] as bool,
      bio: data['bio'] as String, //biografia do membro
      //curriculo
      isProcurandoOportunidades: data['isProcurandoOportunidades'] as bool,
      profissao: data['profissao'] as String,
      pretensaoSalarial: data['pretensaoSalarial'] as String,
      objetivos: data['objetivos'] ?? '',
      bioProfissional: data['bioProfissional'] as String,
      //Registro de membros
      dataRegistro: data['dataRegistro'] as String,
      numeroRegistro: data['numeroRegistro'] as String,
      livroRegistro: data['livroRegistro'] as String,
      paginaRegistro: data['paginaRegistro'] as String,
      //configurações da conta
      isAdmin: data['isAdmin'] as bool,
      isMemberCard: data['isMemberCard'] as bool,
      isVerified: data['isVerified'] as bool,
      isActive: data['isActive'] as bool,
      createdAt: (data['createdAt'] as Timestamp)?.toDate(),
      tags: data['tags'] as List,
      isVerificacaoSolicitada: data['isVerificacaoSolicitada'] as bool,
    );
  }

  //@override
  List get getTags => [
    this.id,
    this.isActive ? 'ativo' : 'inativo',
    this.username != null ? this.username.toLowerCase() : '',
    this.matricula != null ? this.matricula.toLowerCase() : '',
    this.email != null ? this.email.toLowerCase() : '',
    this.cpf,
    this.rg,
    this.dataNascimento,
    this.estadoCivil != null ? this.estadoCivil.toLowerCase() : '',
    this.genero != null ? this.genero.toLowerCase() : '',
    this.tipoSanguineo != null ? this.tipoSanguineo.toLowerCase() : '',
    //Dados eleitorais
    this.tituloEleitor != null ? this.tituloEleitor.toLowerCase() : '',
    this.zonaEleitor != null ? this.zonaEleitor.toLowerCase() : '',
    this.secaoEleitor != null ? this.secaoEleitor.toLowerCase() : '',
    //Necessidades especiais
    this.isPortadorNecessidade ? 'portador de necessidade' : '',
    this.tipoNecessidade != null ? this.tipoNecessidade.toLowerCase() : '',
    //Endereco
    this.cep,
    this.uf != null ? this.uf.toLowerCase() : '',
    this.cidade != null ? this.cidade.toLowerCase() : '',
    this.bairro != null ? this.bairro.toLowerCase() : '',
    this.logradouro != null ? this.logradouro.toLowerCase() : '',
    this.complemento != null ? this.complemento.toLowerCase() : '',
    this.numero != null ? this.numero.toLowerCase() : '',
    //Contatos
    this.numeroFixo,
    this.numeroCelular,
    //Perfil Cristão
    this.congregacao,
    this.tipoMembro != null ? this.tipoMembro.toLowerCase() : '',
    this.situacaoMembro != null ? this.situacaoMembro.toLowerCase() : '',
    this.procedenciaMembro != null ? this.procedenciaMembro.toLowerCase() : '',
    this.origemMembro != null ? this.origemMembro.toLowerCase() : '',
    this.dataMudanca,
    this.dataConversao,
    this.localConversao != null ? this.localConversao.toLowerCase() : '',
    this.dataBatismoAguas,
    this.localBatismoAguas != null ? this.localBatismoAguas.toLowerCase() : '',
    this.dataBatismoEspiritoSanto,
    this.localBatismoEspiritoSanto != null ? this.localBatismoEspiritoSanto.toLowerCase() : '',
    this.isDizimista ? 'dizimista' : 'não dizimista',
    //curriculo
    this.isProcurandoOportunidades ? 'procurando emprego' : '',
    this.profissao != null ? this.profissao.toLowerCase() : '',
    this.pretensaoSalarial != null ? this.pretensaoSalarial.toLowerCase() : '',
    //Registro de membros
    this.dataRegistro,
    this.numeroRegistro != null ? this.numeroRegistro.toLowerCase() : '',
    this.livroRegistro != null ? this.livroRegistro.toLowerCase() : '',
    this.paginaRegistro != null ? this.paginaRegistro.toLowerCase() : '',
    //configurações de conta
    this.isAdmin ? 'administrador' : 'usuario',
    this.isMemberCard ? 'possui cartão de membro': '',
    this.isVerified ? 'verificado' : 'não verificado',
    '*',
  ];

  static Future<UserModel> getUser(String id) async {
    if (id != null) {
      final doc = await FirebaseFirestore.instance.doc('users/$id').get();
      return doc.exists ? UserModel.fromDocument(doc) : UserModel.empty;
    }
    return UserModel.empty;
  }

  static Future<List<UserModel>> getUserBatismo(String dataBatismo) async {
    if (dataBatismo != '') {
      final batizados = await FirebaseFirestore.instance
          .collection('users')
          .where('dataBatismoAguas', isEqualTo: dataBatismo)
          .get();
      final listBatizados =
          batizados.docs.map((doc) => UserModel.fromDocument(doc)).toList();

      return listBatizados;
    }
    return [];
  }

  Future<void> saveUser() async => await firestoreRef.set(toDocument());

  Future<void> updateUser(UserModel user) async {
    return await FirebaseFirestore.instance
        .doc('users/${user.id}')
        .update(user.toDocument());
  }

  Future<List<UserModel>> search({
    @required String campo,
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where(campo, isEqualTo: value)
        .get();

    final list = result.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    return list;
  }

  //@override
  static Future<List<UserModel>> searchTags({
    @required String value,
  }) async {
    if (value != '') {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('tags', arrayContains: value.toLowerCase())
          .get();

      final list =
          result.docs.map((doc) => UserModel.fromDocument(doc)).toList();
      return list;
    }
    return [];
  }
}
