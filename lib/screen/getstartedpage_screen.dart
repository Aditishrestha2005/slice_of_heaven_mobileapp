import 'package:flutter/material.dart';
import '../features/auth/presentation/pages/signuppage_screen.dart';

class GetStartedPageScreen extends StatelessWidget {
  const GetStartedPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Stack(
        children: [
          
          Positioned.fill(
            child: Image.asset(
              "assets/images/getstartedpage.jpg",
           
              fit: BoxFit.cover,
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    
                      Text(
                        "Slice of",
                        style: TextStyle(
                          fontFamily: "Cursive",
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 223, 108, 7),
                        ),
                      ),
                   
                      Text(
                        "Heaven",
                        style: TextStyle(
                          fontFamily: "Cursive",
                          fontSize: 45,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                   
                      Center(
                        child: Text(
                          "Order Happiness, Slice by Slice.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

             
              const Expanded(child: SizedBox.shrink()),

              Padding(
                
                padding: const EdgeInsets.only(bottom: 30, right: 30), 
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
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
                          vertical: 12,
                          horizontal: 35,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                      ),
                      child: const Text(
                        "Get started",
                        style: TextStyle(
                          fontFamily: "Cursive",
                          fontSize: 18,
                          color: Color(0xFF1A0B09),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}