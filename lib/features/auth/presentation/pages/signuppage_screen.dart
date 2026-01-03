import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slice_of_heaven/core/utils/snackbar_utils.dart';
import 'package:slice_of_heaven/features/auth/presentation/state/auth_state.dart';
import 'package:slice_of_heaven/features/auth/presentation/view_model/auth_view_model.dart';
import 'loginpage_screen.dart';

// Shared styles (same as Login)
const Color kPrimaryButtonColor = Color.fromARGB(255, 235, 151, 26);
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

class SignuppageScreen extends ConsumerStatefulWidget {
  const SignuppageScreen({super.key});

  @override
  ConsumerState<SignuppageScreen> createState() => _SignuppageScreenState();
}

class _SignuppageScreenState extends ConsumerState<SignuppageScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      SnackbarUtils.showError(context, "Please fill all fields correctly");
      return;
    }

    if (!_acceptTerms) {
      SnackbarUtils.showWarning(context, "Please accept Terms & Privacy Policy");
      return;
    }

    final authVM = ref.read(authViewModelProvider.notifier);

    await authVM.register(
      fullName: fullNameController.text.trim(),
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );

    final state = ref.read(authViewModelProvider);

    if (state.status == AuthStatus.registered) {
      SnackbarUtils.showSuccess(context, "Account created successfully");
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginpageScreen()),
          );
        }
      });
    } else if (state.status == AuthStatus.error) {
      SnackbarUtils.showError(
        context,
        state.errorMessage ?? "Registration failed",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 230, 209),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Slice of Heaven",
                  style: TextStyle(
                    fontFamily: "Cursive",
                    fontSize: 18,
                    color: kPrimaryTextColor,
                  ),
                ),

                const SizedBox(height: 40),

                Center(
                  child: Container(
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
                ),

                const SizedBox(height: 35),
                Center(child: Text("Create Account", style: kHeadingTextStyle)),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Join us and start your fresh shopping journey",
                    style: TextStyle(color: kPrimaryTextColor, fontSize: 15),
                  ),
                ),

                const SizedBox(height: 25),

                /// FULL NAME
                const Text("Full Name", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                const SizedBox(height: 8),
                _textField(
                  controller: fullNameController,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Full name is required" : null,
                ),

                const SizedBox(height: 18),

                /// USERNAME
                const Text("Username", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                const SizedBox(height: 8),
                _textField(
                  controller: usernameController,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? "Username is required" : null,
                ),

                const SizedBox(height: 18),

                /// EMAIL
                const Text("Email", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                const SizedBox(height: 8),
                _textField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Email is required";
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// PASSWORD
                const Text("Password", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                const SizedBox(height: 8),
                _passwordField(
                  controller: passController,
                  visible: _passwordVisible,
                  toggle: () => setState(() => _passwordVisible = !_passwordVisible),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Password is required";
                    if (v.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                /// CONFIRM PASSWORD
                const Text("Confirm Password", style: TextStyle(color: kPrimaryTextColor, fontSize: 16)),
                const SizedBox(height: 8),
                _passwordField(
                  controller: confirmPassController,
                  visible: _confirmPasswordVisible,
                  toggle: () =>
                      setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Confirm your password";
                    if (v != passController.text) return "Passwords do not match";
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (v) => setState(() => _acceptTerms = v!),
                      activeColor: const Color(0xFF6BAA44),
                    ),
                    const Expanded(
                      child: Text(
                        "By signing up, you agree to our Terms & Privacy Policy.",
                        style: TextStyle(color: kPrimaryTextColor, fontSize: 13),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Center(
                  child: SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed:
                          state.status == AuthStatus.loading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: state.status == AuthStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Sign up", style: kButtonTextStyle),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(color: kPrimaryTextColor, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginpageScreen()),
                          );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Color(0xFF6BAA44),
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool visible,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      decoration: _inputDecoration(
        suffix: IconButton(
          icon: Icon(
            visible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black54,
          ),
          onPressed: toggle,
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration({Widget? suffix}) {
  return InputDecoration(
    filled: true,
    fillColor: const Color.fromARGB(255, 216, 164, 100),
    hintText: "",
    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    suffixIcon: suffix,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
  );
}
