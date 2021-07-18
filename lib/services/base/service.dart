import 'package:flutter/material.dart';

import 'model.dart';

abstract class BaseService extends ChangeNotifier {
  //BaseService();

  bool get isLoading;
  set setLoading(bool loading);

  Future<void> load();

  Future<void> create();

  Future<void> update();

  Future<List<BaseModel>> search();

  Future<List<BaseModel>>searchTags();

  Future<BaseModel> getDoc(String id);
}
