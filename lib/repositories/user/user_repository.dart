import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class UserRepository extends ChangeNotifier {
  FirebaseFirestore fb = FirebaseFirestore.instance;

  UserModel user;

  UserRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

/*
  Future<void> saveUser({
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

  */

  Future<void> update({
    @required UserModel user,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      this.user = user;

      await fb.collection('/users').doc(user.id).update(user.toDocument());

      onSuccess(user.id);
    } catch (e) {
      onFail(e.message);
    }

    setLoading = false;
  }
}
