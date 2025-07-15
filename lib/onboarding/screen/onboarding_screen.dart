import 'package:flutter/material.dart';
import 'package:onbording_screens/onboarding/services/shared_pref_service.dart';
import 'package:onbording_screens/screens/Home_screen.dart';
import 'package:onbording_screens/onboarding/data/onboarding_data.dart';
import 'package:onbording_screens/onboarding/widgets/next_button.dart';
import 'package:onbording_screens/onboarding/widgets/onboarding_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose(); 
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      isLastPage = index == onboardingPages.length - 1;
    });
  }

 void _onNextPressed() async {
  if (isLastPage) {
    await SharedPrefService.setOnboardingSeen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  } else {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: onboardingPages.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return OnboardingPage(model: onboardingPages[index]);
                  },
                ),
              ),

              const SizedBox(height: 20),

              SmoothPageIndicator(
                controller: _controller,
                count: onboardingPages.length,
                effect: const WormEffect(
                  dotHeight: 5,
                  dotWidth: 18,
                  activeDotColor: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 30),

              NextButton(
                onPressed: _onNextPressed,
                isLastPage: isLastPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
