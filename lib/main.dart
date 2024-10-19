import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ethosv2/common/routes/routes.dart';
import 'package:ethosv2/common/theme/dark_theme.dart';
import 'package:ethosv2/common/theme/light_theme.dart';
import 'package:ethosv2/feature/auth/controller/auth_controller.dart';
import 'package:ethosv2/feature/home/pages/home_page.dart';
import 'package:ethosv2/feature/welcome/pages/welcome_page.dart';
import 'package:ethosv2/firebase_options.dart';

void main() async {
  try {
    // Ensure Flutter is initialized
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Run app
    runApp(const ProviderScope(child: MyApp()));
  } catch (e) {
    print('Initialization error: $e');
    runApp(const ProviderScope(child: MyApp()));
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CYLO',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      home: Builder(
        builder: (context) {
          // Remove splash screen once we're ready to show the app
          FlutterNativeSplash.remove();

          return ref.watch(userInfoAuthProvider).when(
            data: (user) {
              if (user == null) return const WelcomePage();
              return const HomePage();
            },
            error: (error, trace) {
              return const Scaffold(
                body: Center(
                  child: Text('Something went wrong'),
                ),
              );
            },
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        },
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}