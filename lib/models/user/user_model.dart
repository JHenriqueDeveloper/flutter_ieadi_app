import 'package:cloud_firestore/cloud_firestore.dart';

enum Procedencias {
  BATIZADO_NO_CAMPO,
  CARTA_MUDANCA_MINISTERIO,
  CARTA_MUDANCA_OUTRO_MINISTERIO,
  ACLAMACAO,
}

enum TiposDeMembros {
  MEMBRO,
  CRIANCA,
  CONGREGADO,
  AMIGO_DO_EVANGELHO,
}

enum SituacoesMembros {
  AFASTADO,
  DISCIPLINADO,
  COMUNHAO,
  MUDOU_DE_CAMPO,
  MUDOU_DE_MINISTERIO,
  FALECIDO,
}

enum EstadosCivis {
  SOLTEIRO,
  CASADO,
  DIVORCIADO,
  EMANCEBADO,
  VIUVO,
}

enum Genero {
  MASCULINO,
  FEMININO,
}

enum TiposSanguineos {
  A_POSITIVO,
  A_NEGATIVO,
  B_POSITIVO,
  B_NEGATIVO,
  AB_POSITIVO,
  AB_NEGATIVO,
  O_POSITIVO,
  O_NEGATIVO,
}

enum TiposNecessidadesEspeciais {
  VISUAL,
  AUDITIVA,
  MENTAL,
  FISICA,
}

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
  //DateTime createAt;

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
    //this.createAt,
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
        //'createAt': Timestamp.fromDate(createAt),
      };

  static UserModel empty = UserModel(
    id: '',
    username: '',
    matricula: '',
    email: '',
    profileImageUrl: '',
    //Dados civis
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
    isPortadorNecessidade: false,
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
    //createAt: DateTime.now(),
  );

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    if (doc == null) return null;
    final data = doc.data();
    return UserModel(
      id: doc.id,
      username: data['username'] ?? '',
      matricula: data['matricula'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      //Dados Civis
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
      isPortadorNecessidade: data['isPortadorNecessidade'] ?? false,
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
      isDizimista: data['isDizimista'] ?? false,
      bio: data['bio'] ?? '', //biografia do membro
      //curriculo
      isProcurandoOportunidades: data['isProcurandoOportunidades'] ?? false,
      profissao: data['profissao'] ?? '',
      pretensaoSalarial: data['pretensaoSalarial'] ?? '',
      objetivos: data['objetivos'] ?? '',
      bioProfissional: data['bioProfissional'] ?? '',
      //Registro de membros
      dataRegistro: data['dataRegistro'] ?? '',
      numeroRegistro: data['numeroRegistro'] ?? '',
      livroRegistro: data['livroRegistro'] ?? '',
      paginaRegistro: data['paginaRegistro'] ?? '',
      //configurações da conta
      isAdmin: data['isAdmin'] ?? false,
      isMemberCard: data['isMemberCard'] ?? false,
      isVerified: data['isVerified'] ?? false,
      //createAt: (data['createAt'] as Timestamp)?.toDate() ?? DateTime.now(),
    );
  }

  static Future<UserModel> getUser(String userId) async {
    final doc = await FirebaseFirestore.instance.doc('users/$userId').get();
    return doc.exists ? UserModel.fromDocument(doc) : UserModel.empty;
  }

  Future<void> saveUser() async => await firestoreRef.set(toDocument());

  Future<void> updateUser(UserModel user) async {
    return await FirebaseFirestore
    .instance
    .doc('users/${user.id}')
    .update(user.toDocument());
  }

/*
  Future<void> updateUser({
    UserModel user
  }) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }
*/

}
