import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../components/category_item.dart';
import '../components/product_card.dart';
import '../components/promo_banner.dart';
import '../providers/cart_provider.dart';
import '../providers/home_provider.dart';
import '../theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartCountProvider);
    final categories = ref.watch(categoriesProvider);
    final products = ref.watch(productsProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.lightGreen,
                    child: Icon(Icons.menu, color: AppColors.primary, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Fresh Market',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, color: AppColors.primary, size: 18),
                            SizedBox(width: 4),
                            Text('Downtown, Metropolis', style: TextStyle(color: AppColors.textGrey)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: AppColors.dark,
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary, size: 30),
                  hintText: 'Search fruits, vegetables, plants...',
                  hintStyle: const TextStyle(fontSize: 18, color: Color(0xFFA0AEC0)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const PromoBanner(),
              const SizedBox(height: 28),
              Row(
                children: [
                  const Text('Categories', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              categories.when(
                data: (items) => SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (_, index) {
                      final category = items[index];
                      final icons = [
                        Icons.apple_outlined,
                        Icons.eco_outlined,
                        Icons.local_florist_outlined,
                        Icons.egg_outlined,
                        Icons.bakery_dining_outlined,
                      ];
                      return CategoryItem(
                        label: category.nomCategorie,
                        icon: icons[index % icons.length],
                        selected: index < 3,
                      );
                    },
                  ),
                ),
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )),
                error: (e, _) => Text('Erreur: $e'),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  const Text('Featured Products', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune, color: AppColors.textGrey),
                  )
                ],
              ),
              const SizedBox(height: 8),
              products.when(
                data: (items) => GridView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 18,
                    crossAxisSpacing: 18,
                    childAspectRatio: .67,
                  ),
                  itemBuilder: (_, index) {
                    final product = items[index];
                    return ProductCard(
                      product: product,
                      onAdd: () {
                        ref.read(cartCountProvider.notifier).state++;
                      },
                    );
                  },
                ),
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(),
                )),
                error: (e, _) => Text('Erreur: $e'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: const Color(0xFF97A4B8),
        onTap: (index) {
          if (index == 3) {
            context.go('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_outlined), label: 'Browse'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}