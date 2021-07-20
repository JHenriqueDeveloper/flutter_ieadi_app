import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class AuthRepository extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UserModel user;
  CongregModel congreg;

  Map<String, bool> pendencias = {
    'pessoal': false,
    'cristao': false,
    'endereco': false,
    'curriculo': false,
    'contatos': false,
    'imagemPerfil': false,
    'pendencias': false,
  };

  AuthRepository() {
    _loadCurrentUser();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  bool get isLoggedId => user != null; //verifica se está logado no app

  void _loadCurrentUser({firebaseUser}) async {
    var currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser?.uid != null) {
      this.user = await UserModel.getUser(currentUser.uid);

      pendencias['pessoal'] = isPessoalPendencias(this.user);
      pendencias['cristao'] = isCristaoPendencias(this.user);
      pendencias['endereco'] = isEnderecoPendencias(this.user);
      pendencias['contatos'] = isContatosPendencias(this.user);
      pendencias['curriculo'] = isCurriculoPendencias(this.user);
      pendencias['imagemPerfil'] =
          this.user.profileImageUrl == '' ? true : false;

      pendencias['pendencias'] = pendencias['pessoal'] ??
          pendencias['cristao'] ??
          pendencias['endereco'] ??
          pendencias['contatos'];

      if (this.user.congregacao != '') {
        this.congreg = await CongregModel.getCongreg(this.user.congregacao);
      }

      notifyListeners();
    }
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

      //Adiciona um tempo ao carregamento
      // await Future.delayed(Duration(seconds: 4));

      if (result.user != null) {
        _loadCurrentUser(firebaseUser: result.user);

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
      List<String> tags = [user.username, user.email, '*'];

      user.tags = tags;

      //user.tags.add(user.email);

      var result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      if (result.user != null) {
        user.id = result.user.uid;
        user.createdAt = DateTime.now();
        this.user = user;
        await user.saveUser();

        onSuccess(result.user.uid);

        _loadCurrentUser();
      }
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  void signOut(BuildContext context) {
    auth.signOut();
    user = UserModel.empty;
    user = null;
    notifyListeners();
    Navigator.of(context).pushNamed('/intro');
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

      //var profileImageUrl = user.profileImageUrl;

      // Update user profile image.
      if (user.profileImageUrl.isNotEmpty) {
        final exp = RegExp(r'userProfile_(.*).jpg');
        imageId = exp.firstMatch(user.profileImageUrl)[1];
      }

      user.profileImageUrl = await _firebaseStorage
          .ref('images/users/userProfile_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

      this.user = user;

      await _firebaseFirestore
          .collection('/users')
          .doc(user.id)
          .update(user.toDocument());

      onSuccess(user.id);
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> update({
    @required UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    try {
      this.user = user;
      user.createdAt = user?.createdAt ?? DateTime.now();
      CongregModel congreg = new CongregModel();
      AreasModel area = new AreasModel();
      SetorModel setor = new SetorModel();

      if (user.congregacao != null) {
        congreg = await CongregModel.getCongreg(user.congregacao);
        if (congreg.idArea != null) {
          area = await AreasModel.getArea(congreg.idArea);
          if (area.setor != null) {
            setor = await SetorModel.getSetor(area.setor);
          }
        }
      }
      user.tags = user.getTags;
      user.tags.add(congreg.id != null ? congreg.nome.toLowerCase() ?? '' : '');
      user.tags.add(area.id != null ? area.nome.toLowerCase() ?? '' : '');
      user.tags.add(setor.id != null ? setor.nome.toLowerCase() ?? '' : '');

      user.tags = user.getTags; //tagsList;

      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update(user.toDocument());

      onSuccess(user.id);

      _loadCurrentUser();
    } catch (e) {
      onFail(e);
    }

    setLoading = false;
  }
}
