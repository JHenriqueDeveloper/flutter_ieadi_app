import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class CongregRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CongregModel congreg;

  CongregRepository() {
    loadCongregs(onFail: (e) => print(e));
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<CongregModel> _listCongregs = [];
  List<CongregModel> get getListCongregs => _listCongregs;

  Future<void> loadCongregs({
    Function onFail,
  }) async {
    setLoading = true;
    try {
      final congregs = await _firebaseFirestore.collection('/congregs')
      .orderBy('createdAt', descending: true)
      .get();

      _listCongregs = congregs.docs
          .map(
            (doc) => CongregModel.fromDocument(doc),
          )
          .toList();

      notifyListeners();
    } catch (e) {
      onFail(e);
    }

    if (this.congreg != null) {
      this.congreg = this.congreg.getCongregEmpty;
    }

    setLoading = false;
  }

  Future<void> updateCongreg({
    @required CongregModel congreg,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (image != null) {
        var imageId = Uuid().v4();

        if (congreg.profileImageUrl != null) {
          final exp = RegExp(r'congregProfile_(.*).jpg');
          imageId = exp.firstMatch(congreg.profileImageUrl)[1];
        }

        congreg.profileImageUrl = await _firebaseStorage
            .ref('images/congregs/congregProfile_$imageId.jpg')
            .putFile(image)
            .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      }

      if (congreg.createdAt == null) {
        congreg.setCreatedAt = DateTime.now();
      }

      this.congreg = congreg;

      await _firebaseFirestore
          .collection('/congregs')
          .doc(congreg.id)
          .update(congreg.toDocument());

      onSuccess(congreg.id);
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> addCongreg({
    CongregModel congreg,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (image != null) {
        var imageId = Uuid().v4();

        congreg.profileImageUrl = await _firebaseStorage
            .ref('images/congregs/congregProfile_$imageId.jpg')
            .putFile(image)
            .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      }

      congreg.setCreatedAt = DateTime.now();
      congreg.isActive = true;

      var result = await _firebaseFirestore
          .collection('/congregs')
          .add(congreg.toDocument());

      loadCongregs();

      onSuccess(result);

      this.congreg = congreg.getCongregEmpty;
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}

/*
  Future<void> signUp({
    UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      if (result.user != null) {
        user.id = result.user.uid;
        this.user = user;
        await user.saveUser();

        onSuccess(result.user.uid);
      }
    } catch (e) {
      onFail(e.message);
    }
    setLoading = false;
  }
}
*/

/*

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
      //print(this.user.username);
      notifyListeners();
    }
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
      var result = await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      if (result.user != null) {
        user.id = result.user.uid;
        this.user = user;
        await user.saveUser();

        onSuccess(result.user.uid);
      }
    } catch (e) {
      onFail(e.message);
    }
    setLoading = false;
  }

  void signOut(BuildContext context) {
    auth.signOut();
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

      await _firebaseFirestore
          .collection('/users')
          .doc(user.id)
          .update(user.toDocument());

      onSuccess(user.id);
    } catch (e) {
      onFail(e.message);
    }

    setLoading = false;
  }
}


*/
