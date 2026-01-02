import 'package:flutter/material.dart';
import 'package:slice_of_heaven/screen/getstartedpage_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              children: [
                buildPage(
                  image: "assets/images/onboarding_1.jpg",
                  title: "Easy Ordering Experience",
                  subtitle:
                      "Simple steps to choose, customize, and enjoy your favorite pizza.",
                ),
                buildPage(
                  image: "assets/images/onboarding_2.jpg",
                  title: "Made With Fresh Ingredients",
                  subtitle:
                      "Quality toppings and flavors crafted with care.",
                ),
                buildPage(
                  image: "assets/images/onboarding_3.jpg",
                  title: "Hygienic Food Preparation",
                  subtitle:
                      "Clean environment and safe preparation guaranteed.",
                ),
              ],
            ),

         
            Positioned(
              top: 10,
              left: 10,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GetStartedPageScreen(),
                    ),
                  );
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),

           
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
               
                  const SizedBox(width: 80),

               
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 12 : 8,
                        height: currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: currentIndex == index
                              ? Colors.black
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                 
                  TextButton(
                    onPressed: () {
                      if (currentIndex == 2) {
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const GetStartedPageScreen(),
                          ),
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: const Text(
                      "Next",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildPage({
    required String image,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 260),
          const SizedBox(height: 30),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}