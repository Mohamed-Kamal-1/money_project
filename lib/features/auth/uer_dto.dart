import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/user_model.dart';

class UserDto{
  static final _db = FirebaseFirestore.instance;


  static CollectionReference<UserModel> _getUserCollection(){
    return _db.collection('users').withConverter<UserModel>(fromFirestore: (
        snapshot, options) => UserModel.fromMAp(snapshot.data())

      ,toFirestore: (user, options) =>user.toMap(),);
  }


  static Future<void> addUser(UserModel user) async {

    var docReference = await _getUserCollection()
        .doc(user.uid)
        .set(user);
  }

  static Future<UserModel?> getUserById(String? uid) async{
    var doc = await _getUserCollection().doc(uid).get();
    return doc.data();
  }


}