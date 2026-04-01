import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';
import '../theme/app_colors.dart';

class EditProfileScreen extends ConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      body: SafeArea(
        child: profile.when(
          data: (user) {
            final fullNameController = TextEditingController(text: '${user.nom} ${user.prenom}');
            final emailController = TextEditingController(text: user.email);
            final phoneController = TextEditingController(text: user.numTel ?? '+1(555) 000-1234');

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 28)),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.lightGreen,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.check, color: AppColors.primary, size: 28),
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
                              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
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
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Center(
                    child: Text(
                      'Premium Member',
                      style: TextStyle(color: AppColors.primary, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'PERSONAL INFORMATION',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  const Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _profileField(fullNameController),
                  const SizedBox(height: 20),
                  const Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _profileField(emailController),
                  const SizedBox(height: 20),
                  const Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  _profileField(phoneController),
                  const SizedBox(height: 28),
                  const Text(
                    'ACCOUNT ACTIONS',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 18),
                  _actionTile(Icons.receipt_long_outlined, 'Order History'),
                  const SizedBox(height: 14),
                  _actionTile(Icons.settings_outlined, 'App Settings'),
                  const SizedBox(height: 14),
                  _actionTile(Icons.notifications_none, 'Notifications', trailing: _newBadge()),
                  const SizedBox(height: 28),
                  Container(
                    width: double.infinity,
                    height: 62,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF4CACA), width: 2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: AppColors.danger),
                        SizedBox(width: 10),
                        Text(
                          'Log Out',
                          style: TextStyle(color: AppColors.danger, fontSize: 18, fontWeight: FontWeight.w800),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erreur: $e')),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF97A4B8),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'SEARCH'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'ORDERS'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
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

  static Widget _actionTile(IconData icon, String title, {Widget? trailing}) {
    return Container(
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          trailing ??
              const Icon(
                Icons.chevron_right,
                color: AppColors.textGrey,
              ),
        ],
      ),
    );
  }

  static Widget _newBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFD8F2CB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '3 New',
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
      ),
    );
  }
}