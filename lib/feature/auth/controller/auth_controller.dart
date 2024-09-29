import 'package:ethosv2/feature/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider= Provider(
      (ref){
        final authRepository = ref.watch(authRepositoryProvider);
        return AuthController(authRepository: authRepository);
      },
);
class AuthController {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  void verifySmsCodex({
    required BuildContext context,
    required String smsCodeId,
    required String smsCode,
    required bool mounted,
  }){
    authRepository.verifySmsCodex(
      context: context,
      smsCodeId: smsCodeId,
      smsCode: smsCode,
      mounted: mounted,
    );

  }

  void sendSmsCode({
    required BuildContext context,
    required String? phoneNumber,
  }) {
    authRepository.sendSmsCode(
        context: context,
        phoneNumber: phoneNumber!,
    );
  }
}