import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_text_field.dart';
import '../components/primary_button.dart';
import '../components/social_button.dart';
import '../theme/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final fullNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back, size: 28)),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                height: 360,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: const DecorationImage(
                    image: NetworkImage('https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?q=80&w=1200&auto=format&fit=crop'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black.withOpacity(.55), Colors.transparent],
                    ),
                  ),
                  child: const Text(
                    'Join Verte Cueillette',
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Start your journey with organic and fresh harvests today.',
                style: TextStyle(fontSize: 16, color: AppColors.textGrey),
              ),
              const SizedBox(height: 28),
              const Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              AppTextField(
                controller: fullNameCtrl,
                hintText: 'John Doe',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              const Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              AppTextField(
                controller: emailCtrl,
                hintText: 'john@example.com',
                prefixIcon: Icons.mail_outline,
              ),
              const SizedBox(height: 20),
              const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              AppTextField(
                controller: passwordCtrl,
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              const Text('Confirm Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              AppTextField(
                controller: confirmPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: Icons.shield_outlined,
                obscureText: true,
              ),
              const SizedBox(height: 28),
              PrimaryButton(
                text: 'Sign Up',
                onPressed: () => context.go('/home'),
              ),
              const SizedBox(height: 26),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Or continue with', style: TextStyle(color: AppColors.textGrey)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  SocialButton(text: 'Google', assetOrLetter: 'G', onTap: () {}),
                  const SizedBox(width: 14),
                  SocialButton(text: 'Facebook', assetOrLetter: 'f', onTap: () {}),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Wrap(
                  children: [
                    const Text('Already have an account? ', style: TextStyle(color: AppColors.textGrey)),
                    GestureDetector(
                      onTap: () => context.go('/sign-in'),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}