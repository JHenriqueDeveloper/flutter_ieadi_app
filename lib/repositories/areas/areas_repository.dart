import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class AreasRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //AreasModel areas;
  AreasModel area;

  AreasRepository() {
    loadAreas();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<AreasModel> _listAreas = [];
  List<AreasModel> get getListAreas => _listAreas;

  AreasModel getArea(String id) {
    for (AreasModel e in _listAreas) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<List<AreasModel>> searchTags(String value) async {
    setLoading = true;
    List<AreasModel> listagem = await AreasModel.searchTags(value: value);
    setLoading = false;
    return listagem;
  }

  Future<void> loadAreas() async {
    setLoading = true;
    try {
      final areas = await _firebaseFirestore
          .collection('/areas')
          .orderBy('nome')
          //.orderBy('createdAt', descending: true)
          .get();

      _listAreas =
          areas.docs.map((doc) => AreasModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar as áreas \n $e');
    }

    if (this.area != null) {
      this.area = null;
    }

    setLoading = false;
  }

  Future<void> updateArea({
    @required AreasModel area,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (area.createdAt == null) {
        area.setCreatedAt = DateTime.now();
      }

      UserModel supervisor = new UserModel();
      SetorModel setor = new SetorModel();
      CongregModel sede = new CongregModel();

      if (area.setor != null) {
        setor = await SetorModel.getSetor(area.setor);
      }

      if (area.sede != null) {
        sede = await CongregModel.getCongreg(area.sede);
      }

      if (area.supervisor != null) {
        supervisor = await UserModel.getUser(area.supervisor);
      }

      area.tags = area.getTags;
      area.tags.add( 
        supervisor.id != null ? supervisor.username.toLowerCase() ?? '' : '');
      area.tags.add(sede.id != null ? sede.nome.toLowerCase() ?? '' : '');
      area.tags.add(setor.id != null ? setor.nome.toLowerCase() ?? '' : '');

      area.tags = area.getTags; //tagsList;

      await _firebaseFirestore
          .collection('/areas')
          .doc(area.id)
          .update(area.toDocument());

      onSuccess(area.id);

      this.area = area.getEmpty;

      loadAreas();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> addarea({
    AreasModel area,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      area.setCreatedAt = DateTime.now();
      area.isActive = true;

      UserModel supervisor = new UserModel();
      SetorModel setor = new SetorModel();
      CongregModel sede = new CongregModel();

      if (area.setor != null) {
        setor = await SetorModel.getSetor(area.setor);
      }

      if (area.sede != null) {
        sede = await CongregModel.getCongreg(area.sede);
      }

      if (area.supervisor != null) {
        supervisor = await UserModel.getUser(area.supervisor);
      }

      area.tags = area.getTags;
      area.tags.add( 
        supervisor.id != null ? supervisor.username.toLowerCase() ?? '' : '');
      area.tags.add(sede.id != null ? sede.nome.toLowerCase() ?? '' : '');
      area.tags.add(setor.id != null ? setor.nome.toLowerCase() ?? '' : '');

      area.tags = area.getTags; //tagsList;

      var result =
          await _firebaseFirestore.collection('/areas').add(area.toDocument());

      onSuccess(result);

      //this.areas = area.getEmpty;
      this.area = area.getEmpty;

      loadAreas();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}
