abstract class BaseModel {
  BaseModel();
  String get getCollection;
  get getEmpty;
  List get getTags;
  Map<String, dynamic> toDocument();
}
