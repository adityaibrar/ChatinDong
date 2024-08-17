import 'dart:developer';

import 'package:chatin_dong/features/dashboard/presentation/pages/dashboard_page.dart';

import '../widgets/custom_texfield.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/theme.dart';

import '../bloc/authentication_bloc.dart';
import '../widgets/custom_button.dart';
import 'register_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-page';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Berhasil Login')));
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.e)));
            log(state.e);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(120),
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(120),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Login',
                              style: whiteTextStyle.copyWith(
                                fontWeight: bold,
                                fontSize: 35,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 20,
                                bottom: 10,
                              ),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: whiteColor,
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                'assets/icons/logo_app.svg',
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'Login to your account',
                          style: whiteTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          'to access all features',
                          style: whiteTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 50,
                ),
                child: Column(
                  children: [
                    InputField(
                      controller: _emailController,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    InputField(
                      controller: _passwordController,
                      labelText: 'Password',
                      obscureText: _isObscure,
                      suffixIcon:
                          _isObscure ? Icons.visibility : Icons.visibility_off,
                      onSuffixIconPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                      maxLine: 1,
                    ),
                    const SizedBox(height: 40),
                    CustomButton(
                      title: 'Login',
                      backgroundColor: primaryColor,
                      titleColor: whiteColor,
                      onPressed: () {
                        log(_emailController.text);
                        log(_passwordController.text);
                        context.read<AuthenticationBloc>().add(
                              Login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'dont have an account?',
                          style: blackTextStyle.copyWith(
                            fontWeight: medium,
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RegisterScreen.routeName,
                            );
                          },
                          child: Text(
                            ' Register',
                            style: blackTextStyle.copyWith(
                              color: secondaryColor,
                              fontWeight: semiBold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
