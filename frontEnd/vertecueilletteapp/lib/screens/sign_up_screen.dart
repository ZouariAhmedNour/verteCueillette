import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/api/api_exception.dart';
import 'package:vertecueilletteapp/api/auth_api.dart';
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
  final villeCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  final AuthApi _authApi = AuthApi();

  Future<void> _register() async {
    final fullName = fullNameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final ville = villeCtrl.text.trim();
    final password = passwordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    if (fullName.isEmpty ||
        email.isEmpty ||
        ville.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un email valide.')),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit contenir au moins 6 caractères.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Les mots de passe ne correspondent pas.'),
        ),
      );
      return;
    }

    final parts = fullName
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir votre nom complet.')),
      );
      return;
    }

    final prenom = parts.first;
    final nom = parts.length > 1 ? parts.sublist(1).join(' ') : parts.first;

    setState(() => isLoading = true);

    try {
      await _authApi.register(
        nom: nom,
        prenom: prenom,
        email: email,
        password: password,
        ville: ville,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Inscription réussie.')));

      context.go('/home');
    } on ApiException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur inattendue : $e')));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    villeCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

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
                  IconButton(
                    onPressed: () => context.go('/sign-in'),
                    icon: const Icon(Icons.arrow_back, size: 28),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
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
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1466692476868-aef1dfb1e735?q=80&w=1200&auto=format&fit=crop',
                    ),
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
                      colors: [
                        Colors.black.withOpacity(.55),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: const Text(
                    'Join Verte Cueillette',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Start your journey with organic and fresh harvests today.',
                style: TextStyle(fontSize: 16, color: AppColors.textGrey),
              ),
              const SizedBox(height: 28),

              const Text(
                'Full Name',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: fullNameCtrl,
                hintText: 'John Doe',
                prefixIcon: Icons.person_outline,
              ),

              const SizedBox(height: 20),
              const Text(
                'Email Address',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: emailCtrl,
                hintText: 'john@example.com',
                prefixIcon: Icons.mail_outline,
              ),

              const SizedBox(height: 20),
              const Text(
                'Ville',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: villeCtrl,
                hintText: 'Tunis',
                prefixIcon: Icons.location_city_outlined,
              ),

              const SizedBox(height: 20),
              const Text(
                'Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: passwordCtrl,
                hintText: '••••••••',
                prefixIcon: Icons.lock_outline,
                obscureText: obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() => obscurePassword = !obscurePassword);
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Confirm Password',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              AppTextField(
                controller: confirmPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: Icons.shield_outlined,
                obscureText: obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(
                      () => obscureConfirmPassword = !obscureConfirmPassword,
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),
              PrimaryButton(
                text: isLoading ? 'Inscription...' : 'Sign Up',
                icon: isLoading ? null : Icons.person_add_alt_1,
                onPressed: isLoading ? null : _register,
              ),

              const SizedBox(height: 26),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  SocialButton(
                    text: 'Google',
                    assetOrLetter: 'G',
                    onTap: () {},
                  ),
                  const SizedBox(width: 14),
                  SocialButton(
                    text: 'Facebook',
                    assetOrLetter: 'f',
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Center(
                child: Wrap(
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.textGrey),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/sign-in'),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
