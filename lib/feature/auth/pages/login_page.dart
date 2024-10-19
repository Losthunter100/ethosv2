import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethosv2/common/extension/custom_theme_extension.dart';
import 'package:ethosv2/common/helper/show_alert_dialog.dart';
import 'package:ethosv2/common/widgets/custom_elevated_button.dart';
import 'package:ethosv2/feature/auth/controller/auth_controller.dart';
import 'package:ethosv2/feature/auth/widgets/custom_text_field.dart';
import 'package:ethosv2/common/widgets/recaptcha_widget.dart'; // Make sure to import this

import '../../../common/utils/coloors.dart';
import '../../../common/widgets/custom_icon_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late TextEditingController countryNameController;
  late TextEditingController countryCodeController;
  late TextEditingController phoneNumberController;
  String? _recaptchaToken;

  sendCodeToPhone() {
    final phoneNumber = phoneNumberController.text;
    final countryName = countryNameController.text;
    final countryCode = countryCodeController.text;

    if (phoneNumber.isEmpty) {
      return showAlertDialog(
        context: context,
        message: "Please enter your phone number",
      );
    } else if (phoneNumber.length < 9) {
      return showAlertDialog(
        context: context,
        message:
        'The phone number you entered is too short for the country: $countryName\n\nInclude your area code if you haven\'t',
      );
    } else if (phoneNumber.length > 10) {
      return showAlertDialog(
        context: context,
        message:
        "The phone number you entered is too long for the country: $countryName",
      );
    } else if (_recaptchaToken == null) {
      return showAlertDialog(
        context: context,
        message: "Please complete the reCAPTCHA verification",
      );
    }

    ref.read(authControllerProvider).sendSmsCode(
      context: context,
      phoneNumber: "+$countryCode$phoneNumber",
      recaptchaToken: _recaptchaToken!,
    );
  }

  // ... rest of the existing methods ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Enter your phone number',
          style: TextStyle(
            color: context.theme.authAppbarTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          CustomIconButton(
            onPressed: () {},
            icon: Icons.more_vert,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... existing widgets ...
            const SizedBox(height: 20),
            Text(
              'Carrier charges may apply',
              style: TextStyle(
                color: context.theme.greyColor,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: RecaptchaWidget(
                siteKey: '6LfY1mUqAAAAAP41a42Z2nA5TbeOh3RrVIACq_CA',
                onVerified: (token) {
                  setState(() {
                    _recaptchaToken = token;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
        onPressed: sendCodeToPhone,
        text: 'NEXT',
        buttonWidth: 90,
      ),
    );
  }
}