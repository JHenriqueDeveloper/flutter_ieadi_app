import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/services/services.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class UserService extends ChangeNotifier {
  //extends BaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String _collection = UserModel().getCollection;
  UserModel model;
  CongregModel congreg;
  List<UserModel> _listagem = [];
  List<UserModel> get getListagem => _listagem;

  UserService() {
    load();
  }

  Map<String, bool> pendencias = {
    'pessoal': false,
    'cristao': false,
    'endereco': false,
    'curriculo': false,
    'contatos': false,
    'imagemPerfil': false,
    'pendencias': false,
  };

  bool get isLoggedId => model != null; //verifica se está logado no app

  UserModel getItem(String id) {
    for (UserModel e in _listagem) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  //@override
  bool get isLoading => _isLoading;

  //@override
  set setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  //@override
  Future<void> load({firebaseUser}) async {
    //void _loadCurrentUser({firebaseUser}) async {
    setLoading = true;
    var currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser?.uid != null) {
      this.model = await UserService().getDoc(currentUser.uid);
      //await UserModel.getUser(currentUser.uid);

      pendencias['pessoal'] = isPessoalPendencias(this.model);
      pendencias['cristao'] = isCristaoPendencias(this.model);
      pendencias['endereco'] = isEnderecoPendencias(this.model);
      pendencias['contatos'] = isContatosPendencias(this.model);
      pendencias['curriculo'] = isCurriculoPendencias(this.model);
      pendencias['imagemPerfil'] =
          this.model.profileImageUrl == '' ? true : false;

      pendencias['pendencias'] = pendencias['pessoal'] ??
          pendencias['cristao'] ??
          pendencias['endereco'] ??
          pendencias['contatos'];

      if (this.model.congregacao != '') {
        this.congreg = await CongregService().getDoc(this.model.congregacao);
        //await CongregModel.get(this.model.congregacao);
      }

      notifyListeners();
    }
    setLoading = false;
  }

  Future<void> signIn({
    UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    try {
      var result = await auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (result.user != null) {
        load(firebaseUser: result.user);

        onSuccess(result.user.uid);
      }
    } catch (e) {
      onFail(e.message);
    }
    setLoading = false;
  }

  Future<void> signUp({
    UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      List<String> tags = [user.username, user.email];

      user.tags = tags;

      //user.tags.add(user.email);

      var result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (result.user != null) {
        user.id = result.user.uid;
        user.createdAt = DateTime.now();
        this.model = user;
        await user.save();

        onSuccess(result.user.uid);

        load();
      }
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  void signOut(BuildContext context) {
    auth.signOut();
    model = UserModel.empty;
    model = null;
    notifyListeners();
    Navigator.of(context).pushNamed('/intro');
  }

  bool isPessoalPendencias(UserModel user) {
    if (user.cpf == '') return true;
    if (user.rg == '') return true;
    if (user.naturalidade == '') return true;
    if (user.nomePai == '') return true;
    if (user.nomeMae == '') return true;
    if (user.dataNascimento == '') return true;
    if (user.estadoCivil == '') return true;
    if (user.genero == '') return true;
    if (user.tituloEleitor != '') {
      if (user.zonaEleitor == '') return true;
      if (user.secaoEleitor == '') return true;
    }
    if (user?.isPortadorNecessidade == true) {
      if (user.tipoNecessidade == '') return true;
      if (user.descricaoNecessidade == '') return true;
      return false;
    }
    return false;
  }

  bool isEnderecoPendencias(UserModel user) {
    if (user.cep == '') return true;
    if (user.uf == '') return true;
    if (user.cidade == '') return true;
    if (user.bairro == '') return true;
    if (user.numero == '') return true;
    return false;
  }

  bool isContatosPendencias(UserModel user) {
    if (user.numeroCelular == '') return true;
    return false;
  }

  bool isCristaoPendencias(UserModel user) {
    if (user.congregacao == '') return true;
    if (user.tipoMembro == '') return true;
    if (user.situacaoMembro == '') return true;
    return false;
  }

  bool isCurriculoPendencias(UserModel user) {
    if (user?.isProcurandoOportunidades == true) {
      if (user.profissao == '') return true;
      if (user.pretensaoSalarial == '') return true;
      if (user.objetivos == '') return true;
      if (user.bioProfissional == '') return true;
    }

    return false;
  }

  //@override
  Future<void> create({
    @required UserModel doc,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      doc.createdAt = DateTime.now();
      doc.isActive = true;
      doc.tags = doc.getTags;

      var result = await _firebaseFirestore
          .collection(_collection)
          .add(doc.toDocument());

      onSuccess(result);

      this.model = doc.getEmpty;

      load();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> updateProfileImage({
    @required UserModel user,
    @required File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      var imageId = Uuid().v4();

      // Update user profile image.
      if (user.profileImageUrl.isNotEmpty) {
        final exp = RegExp(r'userProfile_(.*).jpg');
        imageId = exp.firstMatch(user.profileImageUrl)[1];
      }

      user.profileImageUrl = await _firebaseStorage
          .ref('images/users/userProfile_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

      this.model = user;

      await _firebaseFirestore
          .collection(_collection)
          .doc(user.id)
          .update(user.toDocument());

      onSuccess(user.id);
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  //@override
  Future<void> update({
    @required UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    try {
      this.model = user;
      user.createdAt = user?.createdAt ?? DateTime.now();

      CongregModel congreg = new CongregModel();
      AreaModel area = new AreaModel();
      SetorModel setor = new SetorModel();

      if (user.congregacao != null) {
        congreg = await CongregService().getDoc(user.congregacao);
        if (congreg.idArea != null) {
          area = await AreaService().getDoc(congreg.idArea);
          if (area.setor != null) {
            setor = await SetorService().getDoc(area.setor);
          }
        }
      }
      user.tags = user.getTags;
      user.tags.add(congreg != null ? congreg.nome.toLowerCase() : '');
      user.tags.add(area != null ? area.nome.toLowerCase() : '');
      user.tags.add(setor != null ? setor.nome.toLowerCase() : '');

      await _firebaseFirestore
          .collection(_collection)
          .doc(user.id)
          .update(user.toDocument());

      onSuccess(user.id);

      load();
    } catch (e) {
      onFail(e);
    }

    setLoading = false;
  }

/*
  @override
  Future<void> update({
    @required UserModel doc,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (doc.createdAt == null) {
        doc.createdAt = DateTime.now();
      }

      doc.tags = doc.getTags;

      await _firebaseFirestore
          .collection(_collection)
          .doc(doc.id)
          .update(doc.toDocument());

      onSuccess(doc.id);

      this.model = doc.getEmpty;

      load();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
  */

  //@override
  Future<UserModel> getDoc(String id) async {
    if (id != null) {
      final doc =
          await FirebaseFirestore.instance.doc('$_collection/$id').get();
      return doc.exists ? UserModel.fromDocument(doc) : UserModel.empty;
    }
    return UserModel.empty;
  }

  //@override
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
  Future<List<UserModel>> searchTags({
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where('tags', arrayContains: value.toLowerCase())
        .get();

    final list = result.docs.map((doc) => UserModel.fromDocument(doc)).toList();
    return list;
  }
}
