import 'package:flutter/material.dart';
import 'package:onbording_screens/onboarding/data/onboarding_data.dart';
import 'package:onbording_screens/onboarding/onboarding_page/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onOnboardingComplete;

  const OnboardingScreen({super.key, required this.onOnboardingComplete});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // PageView takes up the entire screen for the onboarding content
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(page: onboardingPages[index]);
            },
          ),
          // Align the indicator and button to the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0, left: 20.0, right: 20.0), // Added padding for better spacing
              child: Column(
                mainAxisSize: MainAxisSize.min, // Use minimum space required by children
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8.0,
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                  const SizedBox(height: 30), // Increased spacing between indicator and button
                  SizedBox(
                    width: double.infinity, // Make button take full width
                    child: ElevatedButton(
                      onPressed: _currentPage == onboardingPages.length - 1
                          ? () async {
                              // Mark onboarding as complete in SharedPreferences
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('onboarding_complete', true);
                              // Call the callback to navigate to the next screen
                              widget.onOnboardingComplete();
                            }
                          : () {
                              // Go to the next page
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.blue, // Added a background color for the button
                        foregroundColor: Colors.white, // Text color for the button
                      ),
                      child: Text(
                        _currentPage == onboardingPages.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Added bold to text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
