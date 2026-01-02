import 'package:flutter/material.dart';
import 'package:slice_of_heaven/common/app_colors.dart';
import 'package:slice_of_heaven/core/utils/snackbar_utils.dart';
import 'package:slice_of_heaven/screen/dashboard_screen.dart';
import 'package:slice_of_heaven/screen/loginpage_screen.dart';

class SignuppageScreen extends StatefulWidget {
  const SignuppageScreen({super.key});

  @override
  State<SignuppageScreen> createState() => _SignuppageScreenState();
}

class _SignuppageScreenState extends State<SignuppageScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  void _register() {
    // Debug prints
    print("Form valid: ${_formKey.currentState!.validate()}");
    print("Terms accepted: $_acceptTerms");

    // Check form validation
    if (!_formKey.currentState!.validate()) {
      SnackbarUtils.showError(context, "Please fill all fields correctly");
      return;
    }

    // Check terms acceptance
    if (!_acceptTerms) {
      SnackbarUtils.showWarning(context, "Please accept Terms & Privacy Policy");
      return;
    }

    // Success
    SnackbarUtils.showSuccess(context, "Account Created Successfully");

    // Navigate to Dashboard after delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0B09),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // App title/logo
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Mini Grocery.",
                      style: const TextStyle(
                        fontFamily: "Cursive",
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Profile placeholder
                  Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[800],
                      image: const DecorationImage(
                        image: AssetImage("assets/images/profile_placeholder.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Icon(Icons.person, size: 60, color: Colors.white54),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Join us and start your fresh shopping journey",
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  // FULL NAME
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Full Name", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFE6C7),
                      hintText: "Full Name",
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Full name is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // EMAIL
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFE6C7),
                      hintText: "Email",
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // PASSWORD
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Password", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFE6C7),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Password is required";
                      }
                      if (value.trim().length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  // CONFIRM PASSWORD
                  const Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("Confirm Password", style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: confirmPassController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFFE6C7),
                      hintText: "Confirm Password",
                      hintStyle: const TextStyle(color: Colors.black54),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Confirm your password";
                      }
                      if (value != passController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  // TERMS CHECKBOX
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            _acceptTerms = value!;
                          });
                        },
                        activeColor: const Color(0xFF6BAA44),
                      ),
                      const Expanded(
                        child: Text(
                          "By signing up, you agree to our Terms & Privacy Policy.",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // SIGN UP BUTTON
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6BAA44),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // LOGIN LINK
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginpageScreen()),
                          );
                        },
                        child: const Text(
                          "Log in.",
                          style: TextStyle(
                            color: Color(0xFF6BAA44),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
