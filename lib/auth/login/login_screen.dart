import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_app/home/chat/chat_list_screen.dart';
import 'package:flutter_chat_app/auth/forget_password/forgot_password_screen.dart';
import 'package:flutter_chat_app/layout/layout_screen.dart';
import 'package:flutter_chat_app/auth/login/login_cubit/login_cubit.dart';
import 'package:flutter_chat_app/auth/singup/signup_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Navigate to the chat screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LayoutScreen()),
              (route) => false,
            );
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: context.read<LoginCubit>().formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/svg/logo.svg', height: 150),
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Material Chat App With Ghazi Hamada',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: context.read<LoginCubit>().emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Iconsax.direct),
                      ),
                      validator:
                          (value) => value!.isEmpty ? 'Enter an email' : null,
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return TextFormField(
                          controller:
                              context.read<LoginCubit>().passwordController,
                          obscureText:
                              context.read<LoginCubit>().isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            prefixIcon: const Icon(Iconsax.password_check),
                            suffixIcon: IconButton(
                              icon: Icon(
                                context.read<LoginCubit>().isPasswordHidden
                                    ? Iconsax.eye_slash
                                    : Iconsax.eye,
                              ),
                              onPressed: () {
                                context
                                    .read<LoginCubit>()
                                    .togglePasswordVisibility();
                              },
                            ),
                          ),
                          validator:
                              (value) =>
                                  value!.isEmpty ? 'Enter a password' : null,
                        );
                      },
                    ),

                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const ForgotPasswordScreen();
                            },
                          ),
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<LoginCubit>().login();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Don\'t have an account? Sign up'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
