import 'package:flutter/material.dart';
import 'signuppage_screen.dart';

class GetStartedPageScreen extends StatelessWidget {
  const GetStartedPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B09), // Dark brown background
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ------------ TOP TITLE TEXT ------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Slice of",
                    style: TextStyle(
                      fontFamily: "Cursive",
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7A00), // Orange
                    ),
                  ),
                  Text(
                    "Heaven",
                    style: TextStyle(
                      fontFamily: "Cursive",
                      fontSize: 42,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "In the Heaven, Eat by Slice.",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ------------ PIZZA IMAGE (FULL WIDTH) ------------
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/pizza_getstarted.png"), // your pizza image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // ------------ GET STARTED BUTTON ------------
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignuppageScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7A00),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
