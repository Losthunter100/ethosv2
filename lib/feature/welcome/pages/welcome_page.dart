import 'package:ethosv2/common/extension/custom_theme_extension.dart';
import 'package:ethosv2/common/routes/routes.dart';
import 'package:ethosv2/common/widgets/custom_elevated_button.dart';
import 'package:ethosv2/feature/welcome/widgets/language_button.dart';
import 'package:ethosv2/feature/welcome/widgets/privacy_and_terms.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  navigateToLoginPage(context){
    Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.login,
        (route)=> false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 10),
              child: Image.asset(
                'assets/images/circle.png',
                color: context.theme.circleImageColor,
              ),
              ),
            ),
          ),
          const SizedBox(height:40),
          Expanded(
            child: Column(
              children: [
                const Text("Welcome to Ethos",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const PrivacyAndTerms(),
                CustomElevatedButton(onPressed: () => navigateToLoginPage(context),
                  text: 'AGREE AND CONTINUE'
                  ,),
                const SizedBox(
                  height: 50,
                ),
                const  LanguageButton()
              ],
            )
          ),
          
        ]

    )
    );
  }
}


