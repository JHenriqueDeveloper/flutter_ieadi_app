import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class UserRepository extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  UserModel user;

  UserRepository() {
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

  void signOut(BuildContext context) {
    auth.signOut();
    user = null;
    notifyListeners();
    Navigator.of(context).pushNamed('/intro');
  }
}
