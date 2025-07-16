import 'package:flutter/material.dart';
import 'package:onbording_screens/Screens/home_screen.dart'; // Re-add this import
import 'package:onbording_screens/onboarding/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _onboardingComplete = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
      _isLoading = false;
    });
  }

  void _setOnboardingComplete() {
    setState(() {
      _onboardingComplete = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Onboarding Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Still show loading while checking
          : _onboardingComplete
              ? const HomeScreen() // Navigate to HomeScreen when onboarding is complete
              : OnboardingScreen(onOnboardingComplete: _setOnboardingComplete),
    );
  }
}