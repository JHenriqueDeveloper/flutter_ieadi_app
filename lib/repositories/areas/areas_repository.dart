import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';

class AreasRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  AreasModel areas;

  AreasRepository() {
    loadAreas(onFail: (e) => print(e));
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<AreasModel> _listAreas = [];
  List<AreasModel> get getListAreas => _listAreas;

  Future<void> loadAreas({
    Function onFail,
  }) async {
    setLoading = true;
    try {
      final areas = await _firebaseFirestore.collection('/areas')
      .orderBy('createdAt', descending: true)
      .get();

      _listAreas = areas.docs
          .map(
            (doc) => AreasModel.fromDocument(doc),
          )
          .toList();

      notifyListeners();
    } catch (e) {
      onFail(e);
    }

    if (this.areas != null) {
      this.areas = this.areas.getEmpty;
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

      this.areas = area;

      await _firebaseFirestore
          .collection('/areas')
          .doc(area.id)
          .update(area.toDocument());

      onSuccess(area.id);
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

      var result = await _firebaseFirestore
          .collection('/areas')
          .add(area.toDocument());

      loadAreas();

      onSuccess(result);

      this.areas = area.getEmpty;
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}