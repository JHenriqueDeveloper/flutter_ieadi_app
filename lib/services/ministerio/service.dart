import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/services/services.dart';
import 'package:meta/meta.dart';

class MinisterioService extends ChangeNotifier{ //extends BaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  bool _isLoading = false;
  String _collection = MinisterioModel().getCollection;
  MinisterioModel model;
  List<MinisterioModel> _listagem = [];
  List<MinisterioModel> get getListagem => _listagem;

  
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

  MinisterioService() {
    load();
  }

  MinisterioModel getItem(String id) {
    for (MinisterioModel e in _listagem) {
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
      final doc = await FirebaseFirestore.instance
          .doc('ministerio/NO9rQnm2ovatGnt2tJNg')
          .get();

      this.model = doc.exists
          ? MinisterioModel.fromDocument(doc)
          : MinisterioModel.empty;
/*
      if (this.model.pastores != null) {
        this.listPastores = [];
        for (var e in this.model.pastores) {
          UserModel pastor = await UserModel.getUser(e);
          this.listPastores.add(pastor);
        }
      }
      if (this.model.evanConsagrados != null) {
        this.listEvanConsagrados = [];
        for (var e in this.model.evanConsagrados) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanConsagrados.add(doc);
        }
      }
      if (this.model.evanAutorizados != null) {
        this.listEvanAutorizados = [];
        for (var e in this.model.evanConsagrados) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanAutorizados.add(doc);
        }
      }
      if (this.model.evanLocais != null) {
        this.listEvanLocais = [];
        for (var e in this.model.evanLocais) {
          UserModel doc = await UserModel.getUser(e);
          this.listEvanLocais.add(doc);
        }
      }
      if (this.model.presbiteros != null) {
        this.listPresbiteros = [];
        for (var e in this.model.presbiteros) {
          UserModel doc = await UserModel.getUser(e);
          this.listPresbiteros.add(doc);
        }
      }
      if (this.model.diaconos != null) {
        this.listDiaconos = [];
        for (var e in this.model.diaconos) {
          UserModel doc = await UserModel.getUser(e);
          this.listDiaconos.add(doc);
        }
      }
      if (this.model.auxiliares != null) {
        this.listAuxiliares = [];
        for (var e in this.model.auxiliares) {
          UserModel doc = await UserModel.getUser(e);
          this.listAuxiliares.add(doc);
        }
      }
      if (this.model.obreiros != null) {
        this.listObreiros = [];
        for (var e in this.model.obreiros) {
          UserModel doc = await UserModel.getUser(e);
          this.listObreiros.add(doc);
        }
      }
      if (this.model.tesoureiros != null) {
        this.listTesoureiros = [];
        for (var e in this.model.tesoureiros) {
          UserModel doc = await UserModel.getUser(e);
          this.listTesoureiros.add(doc);
        }
      }
      if (this.model.secretarios != null) {
        this.listSecretarios = [];
        for (var e in this.model.secretarios) {
          UserModel doc = await UserModel.getUser(e);
          this.listSecretarios.add(doc);
        }
      }
      if (this.model.fiscal != null) {
        this.listFiscal = [];
        for (var e in this.model.fiscal) {
          UserModel doc = await UserModel.getUser(e);
          this.listFiscal.add(doc);
        }
      }
      if (this.model.etica != null) {
        this.listEtica = [];
        for (var e in this.model.etica) {
          UserModel doc = await UserModel.getUser(e);
          this.listEtica.add(doc);
        }
      }

      if (this.model.profileImageUrl != null) {
        this.imageUrl = this.model.profileImageUrl;
      }

      if (this.model.presidente != null) {
        this.presidente = await UserModel.getUser(this.model.presidente);
      }

      if (this.model.sede != null) {
        this.sede = await CongregModel.getCongreg(this.model.sede);
      }
      */

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
    @required MinisterioModel doc,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      doc.createdAt = DateTime.now();
      doc.isActive = true;

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
    @required MinisterioModel doc,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (doc.createdAt == null) {
        doc.createdAt = DateTime.now();
      }

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
  Future<MinisterioModel> getDoc(String id) async {
    if (id != null) {
      final doc =
          await FirebaseFirestore.instance.doc('$_collection/$id').get();
      return doc.exists ? MinisterioModel.fromDocument(doc) : MinisterioModel.empty;
    }
    return MinisterioModel.empty;
  }

  //@override
  Future<List<MinisterioModel>> search({
    @required String campo,
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where(campo, isEqualTo: value)
        .get();

    final list = result.docs.map((doc) => MinisterioModel.fromDocument(doc)).toList();
    return list;
  }

  //@override
  Future<List<MinisterioModel>> searchTags({
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where('tags', arrayContains: value.toLowerCase())
        .get();

    final list = result.docs.map((doc) => MinisterioModel.fromDocument(doc)).toList();
    return list;
  }
}
