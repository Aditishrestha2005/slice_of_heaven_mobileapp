// import 'package:flutter/material.dart';
// import 'package:slice_of_heaven/features/auth/presentation/pages/loginpage_screen.dart';

// class SignuppageScreen extends StatelessWidget {
//   const SignuppageScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1A0B09),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 22),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 10),

//                 const Align(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     "Slice of Heaven.",
//                     style: TextStyle(
//                       fontFamily: "Cursive",
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // Profile Image
//                 Container(
//                   height: 130,
//                   width: 130,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage("assets/images/signupnin.jpg"),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 25),

//                 const Text(
//                   "Register",
//                   style: TextStyle(
//                     fontSize: 28,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 35),

//                 // Email Field
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Email Id",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFFFFE6C7),
//                     hintText: "Email",
//                     hintStyle: const TextStyle(color: Colors.black54),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 16),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 // Password Field
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Password",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFFFFE6C7),
//                     hintText: "Password",
//                     hintStyle: const TextStyle(color: Colors.black54),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 16),
//                     suffixIcon: const Icon(Icons.visibility_off),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 18),

//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Confirm Password",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     filled: true,
//                     fillColor: const Color(0xFFFFE6C7),
//                     hintText: "Confirm Password",
//                     hintStyle: const TextStyle(color: Colors.black54),
//                     suffixIcon: const Icon(Icons.visibility_off),
//                     contentPadding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 16),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 35),

               
//                 SizedBox(
//                   width: 160,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const LoginpageScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFFFF7A00),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(24),
//                       ),
//                     ),
//                     child: const Text(
//                       "Sign up",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 20),

            
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already registered? ",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginpageScreen(),
//                           ),
//                         );
//                       },
//                       child: const Text(
//                         "Login",
//                         style: TextStyle(
//                           color: Color(0xFFFF7A00),
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
