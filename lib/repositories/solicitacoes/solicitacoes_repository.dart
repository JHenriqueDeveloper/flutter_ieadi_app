import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/models/models.dart';
import 'package:uuid/uuid.dart';

class SolicitacoesRepository extends ChangeNotifier {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  SolicitacoesModel solicitacao;
  UserModel membro;

  SolicitacoesRepository() {
    loadSolicitacoes();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set setLoading(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  List<SolicitacoesModel> _listSolicitacoes;
  List<SolicitacoesModel> get getListSolicitacoes => _listSolicitacoes;

  SolicitacoesModel getSolicitacoes(String id) {
    for (SolicitacoesModel e in _listSolicitacoes) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  Future<void> loadSolicitacoes() async {
    setLoading = true;
    try {
      final solicitacoes = await _firebaseFirestore
          .collection('solicitacoes')
          .orderBy('createdAt')
          //.orderBy('createdAt', descending: true)
          .get();

      

      _listSolicitacoes = solicitacoes.docs
          .map((doc) => SolicitacoesModel.fromDocument(doc))
          .toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar Solicitações: \n $e');
    }

    if (this.solicitacao != null) {
      this.solicitacao = null;
    }

    setLoading = false;
  }

  Future<String> addImage({File image, SolicitacoesModel solicitacao}) async {
    if (image != null) {
      var imageId = Uuid().v4();
      if (solicitacao != null) {
        if (solicitacao?.imageUrl != null ?? solicitacao?.imageUrl != '') {
          final exp = RegExp(r'solicitacaoImage_(.*).jpg');
          imageId = exp.firstMatch(solicitacao.imageUrl)[1];
        }
      }

      return await _firebaseStorage
          .ref('images/solicitacoes/solicitacaoImage_$imageId.jpg')
          .putFile(image)
          .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL())
          .catchError((onError) => 'Error: $onError');
    }
    return '';
  }

  Future<void> updateSolicitacao({
    @required SolicitacoesModel solicitacao,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (image != null) {
        solicitacao.imageUrl = await addImage(
          image: image,
          solicitacao: solicitacao,
        );
      }
      if (solicitacao.createdAt == null) {
        solicitacao.createdAt = DateTime.now();
      }

      await _firebaseFirestore
          .collection('/solicitacoes')
          .doc(solicitacao.id)
          .update(solicitacao.toDocument());

      onSuccess(solicitacao.id);

      this.solicitacao = solicitacao.getEmpty;

      loadSolicitacoes();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }

  Future<void> addSolicitacao({
    SolicitacoesModel solicitacao,
    File image,
    Function onFail,
    Function onSuccess,
  }) async {
    setLoading = true;
    try {
      if (image != null) {
        solicitacao.imageUrl = await addImage(image: image);
      }

      solicitacao.createdAt = DateTime.now();
      solicitacao.isActive = true;

      var result = await _firebaseFirestore
          .collection('/solicitacoes')
          .add(solicitacao.toDocument());

      onSuccess(result);

      this.solicitacao = solicitacao.getEmpty;

      loadSolicitacoes();
    } catch (e) {
      onFail(e);
    }
    setLoading = false;
  }
}
