import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class SetorRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  SetorModel setor;

  SetorRepository() {
    loadSetor();
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

  Future<List<SetorModel>> searchTags(String value) async {
    setLoading = true;
    List<SetorModel> listagem = await SetorModel.searchTags(value: value);
    setLoading = false;
    return listagem;
  }

  Future<void> loadSetor() async {
    setLoading = true;
    try {
      final setor = await _firebaseFirestore
          .collection('/setores')
          .orderBy('nome')
          //.orderBy('createdAt', descending: true)
          .get();

      _listSetor = setor.docs
          .map(
            (doc) => SetorModel.fromDocument(doc),
          )
          .toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os setores \n $e');
    }

    if (this.setor != null) {
      this.setor = null;
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

      UserModel supervisor = new UserModel();
      CongregModel sede = new CongregModel();

      if (setor.sede != null) {
        sede = await CongregModel.getCongreg(setor.sede);
      }

      if (setor.supervisor != null) {
        supervisor = await UserModel.getUser(setor.supervisor);
      }

      setor.tags = setor.getTags;
      setor.tags.add( 
        supervisor.id != null ? supervisor.username.toLowerCase() ?? '' : '');
      setor.tags.add(sede.id != null ? sede.nome.toLowerCase() ?? '' : '');

      setor.tags = setor.getTags; //tagsList;

      await _firebaseFirestore
          .collection('/setores')
          .doc(setor.id)
          .update(setor.toDocument());

      this.setor = setor.getEmpty;

      loadSetor();

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

      UserModel supervisor = new UserModel();
      CongregModel sede = new CongregModel();

      if (setor.sede != null) {
        sede = await CongregModel.getCongreg(setor.sede);
      }

      if (setor.supervisor != null) {
        supervisor = await UserModel.getUser(setor.supervisor);
      }

      setor.tags = setor.getTags;
      setor.tags.add( 
        supervisor.id != null ? supervisor.username.toLowerCase() ?? '' : '');
      setor.tags.add(sede.id != null ? sede.nome.toLowerCase() ?? '' : '');

      setor.tags = setor.getTags; //tagsList;

      var result = await _firebaseFirestore
          .collection('/setores')
          .add(setor.toDocument());
      
      this.setor = setor.getEmpty;

      loadSetor();

      onSuccess(result);
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}
