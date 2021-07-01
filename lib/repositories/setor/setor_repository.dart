import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class SetorRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  SetorModel setor;

  SetorRepository() {
    loadSetor(onFail: (e) => print(e));
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<SetorModel> _listSetor = [];
  List<SetorModel> get getListSetor => _listSetor;

  SetorModel getSetor(String id) {
    for (SetorModel e in _listSetor) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<void> loadSetor({
    Function onFail,
  }) async {
    setLoading = true;
    try {
      final setor = await _firebaseFirestore.collection('/setores')
      .orderBy('createdAt', descending: true)
      .get();

      _listSetor = setor.docs
          .map(
            (doc) => SetorModel.fromDocument(doc),
          )
          .toList();

      notifyListeners();
    } catch (e) {
      onFail(e);
    }

    if (this.setor != null) {
      this.setor = this.setor.getEmpty;
    }

    setLoading = false;
  }

  Future<void> updateSetor({
    @required SetorModel setor,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (setor.createdAt == null) {
        setor.setCreatedAt = DateTime.now();
      }

      this.setor = setor;

      await _firebaseFirestore
          .collection('/setores')
          .doc(setor.id)
          .update(setor.toDocument());

      onSuccess(setor.id);
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> addSetor({
    SetorModel setor,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      setor.setCreatedAt = DateTime.now();
      setor.isActive = true;

      var result = await _firebaseFirestore
          .collection('/setores')
          .add(setor.toDocument());

      loadSetor();

      onSuccess(result);

      this.setor = setor.getEmpty;
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}