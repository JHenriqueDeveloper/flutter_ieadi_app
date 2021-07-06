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
    loadMembros(onFail: (e) => print(e));
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

  Future<void> loadMembros({
    Function onFail,
  }) async {
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
      onFail(e);
    }

    if (this.membro != null) {
      this.membro = this.membro.getUserEmpty;
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

    if (image != null) {
      membro.profileImageUrl = await addImage(
        image: image,
        membro: membro,
      );
    }

    this.membro = membro;

    await _firebaseFirestore
        .collection('/users')
        .doc(membro.id)
        .update(membro.toDocument())
        .then((value) => onSuccess(value))
        .catchError((onError) => onFail(onError));

    loadMembros();

    setLoading = false;
  }

  Future<void> addMembro({
    UserModel membro,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

  /*
    membro.matricula = MatriculaHelper(
      userCpf: membro.cpf,
      userId: membro.id,
    ).matricula;

    
*/


    membro.createdAt = DateTime.now();
    membro.isActive = true;
    membro.isVerified = true;

    membro.email = geraEmail(membro?.cpf);
    membro.password = gerarPassword();

    this.membro = membro;
      if (image != null) {
        membro.profileImageUrl = await addImage(image: image);
      }

      await _firebaseFirestore
          .collection('users')
          .add(membro.toDocument())
          .then((value) => onSuccess(value))
          .catchError((onError) => onFail(onError));

      loadMembros();

    setLoading = false;
  }
}
