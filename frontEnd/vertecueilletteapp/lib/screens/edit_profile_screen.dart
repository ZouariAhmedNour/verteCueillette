import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import '../models/user_model.dart';
import '../providers/profile_provider.dart';
import '../theme/app_colors.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _hydrated = false;
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillOnce(UserModel user) {
    if (_hydrated) return;
    _fullNameController.text = '${user.nom} ${user.prenom}';
    _emailController.text = user.email;
    _phoneController.text = user.numTel ?? '';
    _hydrated = true;
  }

  Future<void> _logout() async {
  if (_isLoggingOut) return;

  setState(() => _isLoggingOut = true);

  try {
    SessionManager.clear();

    ref.invalidate(profileProvider);

    if (!mounted) return;
    context.go('/sign-in');
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur logout : $e')),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoggingOut = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      body: SafeArea(
        child: profile.when(
          data: (user) {
            _fillOnce(user);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back, size: 28),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.lightGreen,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.check,
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 82,
                          backgroundColor: const Color(0xFFDDF3D7),
                          child: CircleAvatar(
                            radius: 76,
                            backgroundImage: NetworkImage(
                              user.avatarUrl ??
                                  'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=600&auto=format&fit=crop',
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 8,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: AppColors.primary,
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      '${user.nom} ${user.prenom}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'PERSONAL INFORMATION',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Full Name',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _profileField(_fullNameController),
                  const SizedBox(height: 20),
                  const Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _profileField(_emailController),
                  const SizedBox(height: 20),
                  const Text(
                    'Phone Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  _profileField(_phoneController),
                  const SizedBox(height: 28),
                  const Text(
                    'ACCOUNT ACTIONS',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _actionTile(
                    icon: Icons.receipt_long_outlined,
                    title: 'Order History',
                    onTap: () => context.go('/collections'),
                  ),
                  const SizedBox(height: 28),
                  InkWell(
                    onTap: _isLoggingOut ? null : _logout,
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      width: double.infinity,
                      height: 62,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFF4CACA),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout, color: AppColors.danger),
                          const SizedBox(width: 10),
                          Text(
                            _isLoggingOut ? 'Logging out...' : 'Log Out',
                            style: const TextStyle(
                              color: AppColors.danger,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur: $e')),
        ),
      ),
    );
  }

  static Widget _profileField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  static Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textGrey,
            ),
          ],
        ),
      ),
    );
  }
}