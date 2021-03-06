import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/services/services.dart';
import 'package:meta/meta.dart';

class MembroService extends ChangeNotifier{ //extends BaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String _collection = UserModel().getCollection;
  UserModel model;
  List<UserModel> _listagem = [];
  List<UserModel> get getListagem => _listagem;

  MembroService() {
    load();
  }

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
  set setLoading(bool loading){ 
    _isLoading = loading;
    notifyListeners();
  }

  //@override
  Future<void> load() async {
    setLoading = true;
    try {
      String campo = 'createdAt';

      final result = await _firebaseFirestore
          .collection(_collection)
          .orderBy(campo, descending: true)
          .get();

      _listagem =
          result.docs.map((doc) => UserModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar $_collection \n $e');
    }

    if (this.model != null) {
      this.model = null;
    }

    setLoading = false;
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

  //@override
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
