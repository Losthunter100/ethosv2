import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethosv2/feature/auth/repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../common/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userInfoAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserInfo();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  Stream<UserModel> getUserPresenceStatus({required String uid}) {
    return authRepository.getUserPresenceStatus(uid: uid);
  }

  void updateUserPresence() {
    authRepository.updateUserPresence();
  }

  Future<UserModel?> getCurrentUserInfo() async {
    UserModel? user = await authRepository.getCurrentUserInfo();
    return user;
  }

  void saveUserInfoToFirestore({
    required String username,
    required var profileImage,
    required BuildContext context,
    required bool mounted,
  }) {
    authRepository.saveUserInfoToFirestore(
      username: username,
      profileImage: profileImage,
      ref: ref,
      context: context,
      mounted: mounted,
    );
  }

  Future<bool> verifyRecaptcha(String token) async {
    final response = await http.post(
      Uri.parse('https://www.google.com/recaptcha/api/siteverify'),
      body: {
        'secret': '6LfY1mUqAAAAAP41a42Z2nA5TbeOh3RrVIACq_CA',
        'response': token,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'];
    }
    return false;
  }

  Future<void> verifySmsCode({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
    required String recaptchaToken,
  }) async {
    bool isVerified = await verifyRecaptcha(recaptchaToken);
    if (!isVerified) {
      throw Exception('reCAPTCHA verification failed');
    }

    authRepository.verifySmsCode(
      context: context,
      smsCodeId: smsCodeId,
      smsCode: smsCode,
      mounted: mounted,
    );
  }

  Future<void> sendSmsCode({
    required BuildContext context,
    required String phoneNumber,
    required String recaptchaToken,
  }) async {
    bool isVerified = await verifyRecaptcha(recaptchaToken);
    if (!isVerified) {
      throw Exception('reCAPTCHA verification failed');
    }

    authRepository.sendSmsCode(context: context, phoneNumber: phoneNumber);
  }
}