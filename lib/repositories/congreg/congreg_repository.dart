import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class CongregRepository extends ChangeNotifier {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  CongregModel congreg;

  CongregRepository() {
    loadCongregs();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<CongregModel> _listCongregs;
  List<CongregModel> get getListCongregs => _listCongregs;

  CongregModel getCongreg(String id) {
    for (CongregModel e in _listCongregs) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<void> loadCongregs() async {
    setLoading = true;
    try {
      final congregs = await _firebaseFirestore
          .collection('congregs')
          .orderBy('nome')
          //.orderBy('createdAt', descending: true)
          .get();

      _listCongregs =
          congregs.docs.map((doc) => CongregModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar Congregações: \n $e');
    }

    if (this.congreg != null) {
      this.congreg = null;
    }

    setLoading = false;
  }

  Future<String> addImage({File image, CongregModel congreg}) async {
    if (image != null) {
      var imageId = Uuid().v4();
      if (congreg != null) {
        if (congreg?.profileImageUrl != null ??
            congreg?.profileImageUrl != '') {
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
     try {
       if (image != null) {
        congreg.profileImageUrl = await addImage(
          image: image,
          congreg: congreg,
        );
      }
      if (congreg.createdAt == null) {
        congreg.setCreatedAt = DateTime.now();
      }

      await _firebaseFirestore
          .collection('/congregs')
          .doc(congreg.id)
          .update(congreg.toDocument());

      onSuccess(congreg.id);

      this.congreg = congreg.getCongregEmpty;

      loadCongregs();
      
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
    try{
      if (image != null) {
        congreg.profileImageUrl = await addImage(image: image);
      }

    congreg.setCreatedAt = DateTime.now();
    congreg.isActive = true;

    var result = await _firebaseFirestore
    .collection('/congregs').add(congreg.toDocument());

    onSuccess(result);

    this.congreg = congreg.getCongregEmpty;

    loadCongregs();

    }catch(e){
      onFail(e);
    }
    setLoading = false;
  }
}
