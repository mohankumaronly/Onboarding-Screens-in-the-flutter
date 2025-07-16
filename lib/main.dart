import 'package:flutter/material.dart';
import 'package:onbording_screens/Screens/home_screen.dart'; 
import 'package:onbording_screens/onboarding/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      home: _isLoading
          ? const Center(child: CircularProgressIndicator()) 
          : _onboardingComplete
              ? const HomeScreen() 
              : OnboardingScreen(onOnboardingComplete: _setOnboardingComplete),
    );
  }
}