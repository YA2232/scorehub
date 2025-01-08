import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorehub/business_logic/auth/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:scorehub/constants/strings.dart';
import 'package:scorehub/presentation/widgets/show_modal_signup.dart';

Future<void> showModalSignIn({required BuildContext context}) {
  bool visibility = true;
  bool rememberPassword = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0XFF222232),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    ),
    builder: (context) {
      return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is SuccessAuth) {
            Navigator.of(context).pushReplacementNamed(homeScreen);
          } else if (state is ErrorAuth) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.error.message ?? 'Error')));
          }
        },
        builder: (context, state) {
          bool loading = state is LoadingAuth;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22)),
                  const SizedBox(height: 30),
                  // Email Field
                  _buildTextField(
                      emailController, "Email", Icons.email_outlined),
                  const SizedBox(height: 20),
                  // Password Field
                  _buildTextField(
                      passwordController, "Password", Icons.lock_outline,
                      obscureText: visibility),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberPassword,
                            onChanged: (value) => rememberPassword = value!,
                          ),
                          const SizedBox(width: 6),
                          const Text("Remember Me",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const Text("Forgot Password",
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Sign In Button
                  GestureDetector(
                    onTap: () async {
                      context.read<AuthCubit>().login(emailController.text,
                          passwordController.text, context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0XFF246BFD),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: loading
                            ? const CircularProgressIndicator()
                            : const Text("Sign in",
                                style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Sign Up Text
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showModalSignUp(context: context);
                    },
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(color: Colors.white)),
                            const TextSpan(
                                text: "Sign up",
                                style: TextStyle(color: Color(0XFF246BFD))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField(
    TextEditingController controller, String hintText, IconData icon,
    {bool obscureText = false}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0XFF181829),
    ),
    child: TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.4)),
      ),
    ),
  );
}
