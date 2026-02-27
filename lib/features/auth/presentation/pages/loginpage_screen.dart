import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/utils/snackbar_utils.dart';
import 'package:slice_of_heaven/features/auth/presentation/state/auth_state.dart';
import 'package:slice_of_heaven/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:slice_of_heaven/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'signuppage_screen.dart';

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

class LoginpageScreen extends ConsumerStatefulWidget {
  const LoginpageScreen({super.key});

  @override
  ConsumerState<LoginpageScreen> createState() => _LoginpageScreenState();
}

class _LoginpageScreenState extends ConsumerState<LoginpageScreen> {
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

    // validation
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
      // ✅ IMPORTANT: use AuthViewModel so token is saved
      await ref.read(authViewModelProvider.notifier).login(
            email: email,
            password: password,
          );

      final state = ref.read(authViewModelProvider);

      if (!mounted) return;

      if (state.status == AuthStatus.authenticated) {
        SnackbarUtils.showSuccess(context, "Login successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        SnackbarUtils.showError(
          context,
          state.errorMessage ?? "Login failed",
        );
      }
    } catch (e) {
      if (!mounted) return;
      SnackbarUtils.showError(context, "Login failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

              const Align(
                alignment: Alignment.centerLeft,
                child:
                    Text("Password", style: TextStyle(color: kPrimaryTextColor)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration(
                  "Password",
                  suffix: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black54,
                    ),
                    onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
              ),
              const SizedBox(height: 35),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style:
                          TextStyle(color: kPrimaryTextColor, fontSize: 16)),
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
