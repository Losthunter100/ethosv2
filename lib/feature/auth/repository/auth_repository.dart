import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ethosv2/common/helper/show_alert_dialog.dart';
import 'package:ethosv2/common/models/user_model.dart';
import 'package:ethosv2/common/repository/firebase_storage_repository.dart';
import 'package:ethosv2/common/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider(
  (ref) {
  return AuthRepository(auth:   FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
  );
},
);

class AuthRepository{
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;




void verifySmsCodex({
  required BuildContext context,
  required String smsCodeId,
  required String smsCode,
  required bool mounted,
}) async{
  try{
    final credential = PhoneAuthProvider.credential(
      verificationId: smsCodeId,
      smsCode: smsCode,
    );
    await auth.signInWithCredential(credential);
    if(!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.userInfo,
        (route) => false,
    );
  } on FirebaseAuthException catch(e){
    showAlertDialog(context: context, message: e.toString());
  }

}

  AuthRepository({
    required this.auth,
    required this.firestore
  });
  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required bool mounted,
    required ProviderRef ref,
  })async{
    try{
      String uid = auth.currentUser!.uid;
      String profileImageUrl ='';
      if(profileImage != null){
        profileImageUrl = await ref.
        read(firebaseStorageRepositoryProvider)
            .storeFileToFirebase('profileImage/$uid', profileImage);
      }
      UserModel user= UserModel(
          username: username,
          uid: uid,
          profileImageUrl: profileImageUrl,
          active: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []
      );
      await firestore.collection('users').doc(uid).set(user.toMap());

      if(!mounted) return;

    } catch (e){
      showAlertDialog(context: context, message: e.toString());
    }
  }

  void sendSmsCode({
    required BuildContext context,
    required String phoneNumber,
  }) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential)async{
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e){
          showAlertDialog(context: context, message: e.toString());
        },
        codeSent: (smsCodeId, resendSmsCodeId){
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.verification,
            (routes) => false,
            arguments: {
              'phoneNumber' : phoneNumber,
              'smsCodeId' : smsCodeId,
            },
          );
        },
        codeAutoRetrievalTimeout: (String smsCodeId) {},
      );
    }
    on FirebaseAuth catch(e) {
      showAlertDialog(context: context, message: e.toString());
    }
  }
}