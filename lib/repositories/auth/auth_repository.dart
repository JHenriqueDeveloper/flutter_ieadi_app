import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class AuthRepository extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  void _loadCurrentUser({firebaseUser}) async {
    var currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser.uid != null) {
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
}
