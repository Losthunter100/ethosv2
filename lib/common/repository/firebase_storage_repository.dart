import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethosv2/common/helper/show_alert_dialog.dart';
// import 'package:ethosv2/common/helper/show_loading_dialog.dart';
// import 'package:ethosv2/common/models/user_model.dart';
import 'package:ethosv2/common/repository/firebase_storage_repository.dart';
import 'package:ethosv2/common/routes/routes.dart';

final firebaseStorageRepositoryProvider= Provider((ref) => FirebaseStorageRepository(firebaseStorage: FirebaseStorage.instance),);
class FirebaseStorageRepository{
  final FirebaseStorage firebaseStorage;

  FirebaseStorageRepository({required this.firebaseStorage});

  storeFileToFirebase(String ref, var file) async{
    UploadTask? uploadTask;
    if(file is File){
      uploadTask= firebaseStorage.ref().child(ref).putFile(file);
    }
    if(file is Uint8List){
      uploadTask= firebaseStorage.ref().child(ref).putData(file);
    }
    TaskSnapshot snapshot = await uploadTask!;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }
}