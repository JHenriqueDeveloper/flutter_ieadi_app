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

  CongregModel getCongreg(String id) {
    for (CongregModel e in _listCongregs) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<void> loadCongregs({
    Function onFail,
  }) async {
    setLoading = true;
    try {
      final congregs = await _firebaseFirestore
          .collection('congregs')
          .orderBy('createdAt', descending: true)
          .get();

      _listCongregs =
          congregs.docs.map((doc) => CongregModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      onFail(e);
    }

    if (this.congreg != null) {
      this.congreg = this.congreg.getCongregEmpty;
    }

    setLoading = false;
  }

  Future<String> addImage({File image, CongregModel congreg}) async {
    if (image != null) {
      var imageId = Uuid().v4();
      if (congreg != null) {
        if (congreg?.profileImageUrl != null ?? congreg?.profileImageUrl != '') {
          final exp = RegExp(r'congregProfile_(.*).jpg');
          imageId = exp.firstMatch(congreg.profileImageUrl)[1];
        }
      }

      return await _firebaseStorage
          .ref('images/congregs/congregProfile_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL())
          .catchError((onError) => 'Error: $onError');
    }
    return '';
  }

  Future<void> updateCongreg({
    @required CongregModel congreg,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    if (image != null) {
      congreg.profileImageUrl = await addImage(
        image: image,
        congreg: congreg,
      );
    }

    this.congreg = congreg;

    await _firebaseFirestore
        .collection('/congregs')
        .doc(congreg.id)
        .update(congreg.toDocument())
        .then((value) => onSuccess(value))
        .catchError((onError) => onFail(onError));
    
    loadCongregs();

    setLoading = false;
  }

  Future<void> addCongreg({
    CongregModel congreg,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    if (image != null) {
      congreg.profileImageUrl = await addImage(image: image);
    }
    //congreg.profileImageUrl = await addImage(image: image);
    congreg.setCreatedAt = DateTime.now();
    congreg.isActive = true;

    await _firebaseFirestore
        .collection('congregs')
        .add(congreg.toDocument())
        .then((value) => onSuccess(value))
        .catchError((onError) => onFail(onError));

    loadCongregs();

    setLoading = false;
  }
}
