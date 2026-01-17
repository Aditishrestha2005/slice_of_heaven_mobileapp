import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slice_of_heaven/core/utils/snackbar_utils.dart';
import 'package:slice_of_heaven/screen/dashboard_screen.dart';
import'signuppage_screen.dart';

const Color kPrimaryButtonColor = Color.fromARGB(255, 255, 153, 0);
const Color kPrimaryTextColor = Color.fromARGB(255, 26, 23, 19);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.bold,
);

const TextStyle kHeadingTextStyle = TextStyle(
  fontSize: 28,
  color: kPrimaryTextColor,
  fontWeight: FontWeight.bold,
);

class LoginpageScreen extends StatefulWidget {
  const LoginpageScreen({super.key});

  @override
  State<LoginpageScreen> createState() => _LoginpageScreenState();
}

class _LoginpageScreenState extends State<LoginpageScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Basic validation
    if (email.isEmpty) {
      SnackbarUtils.showError(context, "Email is required");
      return;
    }
    if (!email.contains('@')) {
      SnackbarUtils.showError(context, "Enter a valid email");
      return;
    }
    if (password.isEmpty) {
      SnackbarUtils.showError(context, "Password is required");
      return;
    }
    if (password.length < 6) {
      SnackbarUtils.showError(context, "Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);

      SnackbarUtils.showSuccess(context, "Login successful");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } catch (e) {
      SnackbarUtils.showError(context, "Login failed: $e");
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 230, 209),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Slice of Heaven",
                  style: TextStyle(
                    fontFamily: "Cursive",
                    fontSize: 18,
                    color: kPrimaryTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 130,
                width: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/signupnin.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Text("Login", style: kHeadingTextStyle),
              const SizedBox(height: 40),

              // Email field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Email", style: TextStyle(color: kPrimaryTextColor)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email"),
              ),
              const SizedBox(height: 25),

              // Password field
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Password", style: TextStyle(color: kPrimaryTextColor)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  "Password",
                  suffix: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 35),

              // Login button
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryButtonColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Login", style: kButtonTextStyle),
                ),
              ),
              const SizedBox(height: 30),

              // Sign up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const SignuppageScreen()),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color.fromARGB(255, 80, 194, 74),
                        fontSize: 17,
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
    );
  }
}

InputDecoration _inputDecoration(String hint, {Widget? suffix}) {
  return InputDecoration(
    filled: true,
    fillColor: const Color.fromARGB(255, 216, 164, 100),
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.black54),
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    suffixIcon: suffix,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
  );
}
