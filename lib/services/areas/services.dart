import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ieadi_app/services/services.dart';
import 'package:meta/meta.dart';

class AreaService extends BaseService {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  String _collection = AreaModel().getCollection;
  AreaModel model;
  List<AreaModel> _listagem = [];
  List<AreaModel> get getListagem => _listagem;

  AreaService() {
    load();
  }

  AreaModel getItem(String id) {
    for (AreaModel e in _listagem) {
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
          result.docs.map((doc) => AreaModel.fromDocument(doc)).toList();

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
    @required AreaModel doc,
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
    @required AreaModel doc,
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
  Future<AreaModel> getDoc(String id) async {
    if (id != null) {
      final doc =
          await FirebaseFirestore.instance.doc('$_collection/$id').get();
      return doc.exists ? AreaModel.fromDocument(doc) : AreaModel.empty;
    }
    return AreaModel.empty;
  }

  @override
  Future<List<AreaModel>> search({
    @required String campo,
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where(campo, isEqualTo: value)
        .get();

    final list = result.docs.map((doc) => AreaModel.fromDocument(doc)).toList();
    return list;
  }

  @override
  Future<List<AreaModel>> searchTags({
    @required String value,
  }) async {
    final result = await FirebaseFirestore.instance
        .collection(_collection)
        .where('tags', arrayContains: value.toLowerCase())
        .get();

    final list = result.docs.map((doc) => AreaModel.fromDocument(doc)).toList();
    return list;
  }
}
