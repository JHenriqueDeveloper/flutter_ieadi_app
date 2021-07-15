import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class MinisterioRepository extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  MinisterioModel ministerio;
  CongregModel sede;
  String imageUrl;

  UserModel membros;
  UserModel presidente;
  UserModel vicePresidente;
  UserModel presidenteEtica;
  UserModel presidenteFiscal;

  List<UserModel> listPastores = [];
  List<UserModel> listEvanConsagrados = [];
  List<UserModel> listEvanAutorizados = [];
  List<UserModel> listEvanLocais = [];
  List<UserModel> listPresbiteros = [];
  List<UserModel> listDiaconos = [];
  List<UserModel> listAuxiliares = [];
  List<UserModel> listObreiros = [];
  List<UserModel> listTesoureiros = [];
  List<UserModel> listSecretarios = [];
  List<UserModel> listFiscal = [];
  List<UserModel> listEtica = [];

  MinisterioRepository() {
    load();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  void load() async {
    setLoading = true;
    try {
      final doc = await FirebaseFirestore.instance
          .doc('ministerio/NO9rQnm2ovatGnt2tJNg')
          .get();

      this.ministerio = doc.exists
          ? MinisterioModel.fromDocument(doc)
          : MinisterioModel.empty;

      if (this.ministerio.pastores != null) {
        this.listPastores = [];
        for (var e in this.ministerio.pastores) {
          UserModel pastor = await UserModel.getUser(e);
          this.listPastores.add(pastor);
        }
      }
      if (this.ministerio.evanConsagrados != null) {
        this.listEvanConsagrados = [];
        for (var e in this.ministerio.evanConsagrados) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanConsagrados.add(doc);
        }
      }
      if (this.ministerio.evanAutorizados != null) {
        this.listEvanAutorizados = [];
        for (var e in this.ministerio.evanConsagrados) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanAutorizados.add(doc);
        }
      }
      if (this.ministerio.evanLocais != null) {
        this.listEvanLocais = [];
        for (var e in this.ministerio.evanLocais) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanLocais.add(doc);
        }
      }
      if (this.ministerio.presbiteros != null) {
        this.listPresbiteros = [];
        for (var e in this.ministerio.presbiteros) {
          UserModel doc = await UserModel.getUser(e);
          this.listPresbiteros.add(doc);
        }
      }
      if (this.ministerio.diaconos != null) {
        this.listDiaconos = [];
        for (var e in this.ministerio.diaconos) {
          UserModel doc = await UserModel.getUser(e);
          this.listDiaconos.add(doc);
        }
      }
      if (this.ministerio.auxiliares != null) {
        this.listAuxiliares = [];
        for (var e in this.ministerio.auxiliares) {
          UserModel doc = await UserModel.getUser(e);
          this.listAuxiliares.add(doc);
        }
      }
      if (this.ministerio.obreiros != null) {
        this.listObreiros = [];
        for (var e in this.ministerio.obreiros) {
          UserModel doc = await UserModel.getUser(e);
          this.listObreiros.add(doc);
        }
      }
      if (this.ministerio.tesoureiros != null) {
        this.listTesoureiros = [];
        for (var e in this.ministerio.tesoureiros) {
          UserModel doc = await UserModel.getUser(e);
          this.listTesoureiros.add(doc);
        }
      }
      if (this.ministerio.secretarios != null) {
        this.listSecretarios = [];
        for (var e in this.ministerio.secretarios) {
          UserModel doc = await UserModel.getUser(e);
          this.listSecretarios.add(doc);
        }
      }
      if (this.ministerio.fiscal != null) {
        this.listFiscal = [];
        for (var e in this.ministerio.fiscal) {
          UserModel doc = await UserModel.getUser(e);
          this.listFiscal.add(doc);
        }
      }
      if (this.ministerio.etica != null) {
        this.listEtica = [];
        for (var e in this.ministerio.etica) {
          UserModel doc = await UserModel.getUser(e);
          this.listEtica.add(doc);
        }
      }

      if (this.ministerio.profileImageUrl != null) {
        this.imageUrl = this.ministerio.profileImageUrl;
      }

      if (this.ministerio.presidente != null) {
        this.presidente = await UserModel.getUser(this.ministerio.presidente);
      }

      if (this.ministerio.sede != null) {
        this.sede = await CongregModel.getCongreg(this.ministerio.sede);
      }

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar o ministério \n $e');
    }
    setLoading = false;
  }

  Future<String> addImage({File image, MinisterioModel ministerio}) async {
    if (image != null) {
      var imageId = Uuid().v4();

      final exp = RegExp(r'ministerioProfile_(.*).jpg');
      imageId = exp.firstMatch(ministerio.profileImageUrl)[1];

      return await _firebaseStorage
          .ref('images/ministerio/ministerioProfile_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL())
          .catchError((onError) => 'Error: $onError');
    }
    return '';
  }

  Future<void> updateMinisterio({
    @required MinisterioModel ministerio,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;

    if (image != null) {
      ministerio.profileImageUrl = await addImage(
        image: image,
        ministerio: ministerio,
      );
    }

    if (ministerio.createdAt == null) {
      ministerio.createdAt = DateTime.now();
    }

    this.ministerio = ministerio;

    await _firebaseFirestore
        .collection('/ministerio')
        .doc('NO9rQnm2ovatGnt2tJNg')
        .update(ministerio.toDocument())
        .then((value) => onSuccess(value))
        .catchError((onError) => onFail(onError));

    load();

    setLoading = false;
  }
}
