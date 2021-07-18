import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';
import 'package:meta/meta.dart';

class CongregService extends BaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String _collection = CongregModel().getCollection;
  CongregModel model;
  List<CongregModel> _listagem = [];
  List<CongregModel> get getListagem => _listagem;

  CongregService() {
    load();
  }

  CongregModel getItem(String id) {
    for (CongregModel e in _listagem) {
      if (e.id == id) {
        return e;
      }
    }
    return null;
  }

  @override
  bool get isLoading => _isLoading;

   @override
  set setLoading(bool loading){ 
    _isLoading = loading;
    notifyListeners();
  }

  @override
  Future<void> load() async {
    setLoading = true;
    try {
      String campo = 'nome';

      final result = await _firebaseFirestore
          .collection(_collection)
          .orderBy(campo)
          //.orderBy('createdAt', descending: true)
          .get();

      _listagem =
          result.docs.map((doc) => CongregModel.fromDocument(doc)).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar $_collection \n $e');
    }

    if (this.model != null) {
      this.model = null;
    }

    setLoading = false;
  }

  @override
  Future<void> create({
    @required CongregModel doc,
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

  @override
  Future<void> update({
    @required CongregModel doc,
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

  @override
  Future<CongregModel> getDoc(String id) async {
    if (id != null) {
      final doc =
          await FirebaseFirestore.instance.doc('$_collection/$id').get();
      return doc.exists ? CongregModel.fromDocument(doc) : CongregModel.empty;
    }
    return CongregModel.empty;
  }

  @override
  Future<List<CongregModel>> search({
    @required String campo,
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where(campo, isEqualTo: value)
        .get();

    final list = result.docs.map((doc) => CongregModel.fromDocument(doc)).toList();
    return list;
  }

  @override
  Future<List<CongregModel>> searchTags({
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where('tags', arrayContains: value.toLowerCase())
        .get();

    final list = result.docs.map((doc) => CongregModel.fromDocument(doc)).toList();
    return list;
  }
}
