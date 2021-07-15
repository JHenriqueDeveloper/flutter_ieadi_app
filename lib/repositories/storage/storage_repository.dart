import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

class StorageRepository {
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

/*
  StorageRepository({FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;
*/

  Future<String> _uploadImage({
    @required File image,
    @required String ref,
  }) async {
    final downloadUrl = await _firebaseStorage
        .ref(ref)
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
    return downloadUrl;
  }

  Future<String> uploadProfileImage({
    @required String url,
    @required File image,
  }) async {
    try {
      var imageId = Uuid().v4();

      //print('upload profile image: ${image.path}');

      // Update user profile image.
      if (url.isNotEmpty) {
        final exp = RegExp(r'userProfile_(.*).jpg');
        imageId = exp.firstMatch(url)[1];
      }

      final downloadUrl = await _firebaseStorage
        .ref('images/users/userProfile_$imageId.jpg')
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
      /*
      final downloadUrl = await _uploadImage(
        image: image,
        ref: 'images/users/userProfile_$imageId.jpg',
      );
      */
      return downloadUrl;
    } catch (e) {
      return e;
    }
  }

  Future<String> uploadPostImage({@required File image}) async {
    final imageId = Uuid().v4();
    final downloadUrl = await _uploadImage(
      image: image,
      ref: 'images/posts/post_$imageId.jpg',
    );
    return downloadUrl;
  }
}
