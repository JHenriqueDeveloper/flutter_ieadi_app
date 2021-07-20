import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/helpers/util.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class MembroRepository extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  UserModel membro;

  MembroRepository() {
    loadMembros();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<UserModel> _listMembros = [];
  List<UserModel> get getListMembros => _listMembros;

  UserModel getmembro(String id) {
    for (UserModel e in _listMembros) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<List<UserModel>> getBatismoMembros(String data) async {
    setLoading = true;
    List<UserModel> listBatizados = await UserModel.getUserBatismo(data);
    setLoading = false;
    return listBatizados;
  }

  Future<List<UserModel>> searchTags(String value) async {
    setLoading = true;
    List<UserModel> listagem = await UserModel.searchTags(value: value);
    setLoading = false;
    return listagem;
  }

  Future<void> loadMembros() async {
    setLoading = true;
    try {
      final membros = await _firebaseFirestore
          .collection('users')
          .orderBy('createdAt', descending: true)
          .get();

      _listMembros =
          membros.docs.map((doc) => UserModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os membros \n $e');
    }

    if (this.membro != null) {
      this.membro = null;
    }

    setLoading = false;
  }

  Future<String> addImage({File image, UserModel membro}) async {
    if (image != null) {
      var imageId = Uuid().v4();
      if (membro != null) {
        if (membro?.profileImageUrl != null ?? membro?.profileImageUrl != '') {
          final exp = RegExp(r'userProfile_(.*).jpg');
          imageId = exp.firstMatch(membro.profileImageUrl)[1];
        }
      }

      return await _firebaseStorage
          .ref('images/users/userProfile_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL())
          .catchError((onError) => 'Error: $onError');
    }
    return '';
  }

  Future<void> updateMembro({
    @required UserModel membro,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      CongregModel congreg = new CongregModel().getCongregEmpty;
      AreasModel area = new AreasModel();
      SetorModel setor = new SetorModel();

    if (membro.congregacao != null) {
      congreg = await CongregModel.getCongreg(membro.congregacao);
      if (congreg.idArea != null) {
        area = await AreasModel.getArea(congreg.idArea);
        if (area.setor != null) {
          setor = await SetorModel.getSetor(area.setor);
        }
      }
    }
    membro.tags = membro.getTags;
    membro.tags.add(congreg.id != null ? congreg.nome.toLowerCase() ?? '' : '');
    membro.tags.add(area.id != null ? area.nome.toLowerCase() ?? '' : '');
    membro.tags.add(setor.id != null ? setor.nome.toLowerCase() ?? '' : '');

    membro.tags = membro.getTags; //tagsList;

    if (image != null) {
      membro.profileImageUrl = await addImage(
        image: image,
        membro: membro,
      );
    }

    await _firebaseFirestore
        .collection('/users')
        .doc(membro.id)
        .update(membro.toDocument());

    this.membro = membro.getUserEmpty;

    onSuccess(membro.id);

    loadMembros();
    
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> addMembro({
    UserModel membro,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    membro.createdAt = DateTime.now();
    membro.isActive = true;
    membro.isVerified = true;

    membro.email = geraEmail(membro?.cpf);
    membro.password = gerarPassword();

    if (image != null) {
      membro.profileImageUrl = await addImage(image: image);
    }

    await _firebaseFirestore
        .collection('users')
        .add(membro.toDocument())
        .then((value) => onSuccess(value))
        .catchError((onError) => onFail(onError));

    this.membro = membro.getUserEmpty;

    loadMembros();

    setLoading = false;
  }
}
