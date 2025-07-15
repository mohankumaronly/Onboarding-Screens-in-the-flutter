import 'package:flutter/material.dart';
import 'package:onbording_screens/screens/Home_screen.dart';
import 'package:onbording_screens/onboarding/screen/onboarding_screen.dart';
import 'package:onbording_screens/onboarding/services/shared_pref_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkFirstTime() async {
    return await SharedPrefService.isFirstTimeUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final bool isFirstTime = snapshot.data ?? true;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: isFirstTime ? const OnboardingScreen() : const HomeScreen(),
        );
      },
    );
  }
}
