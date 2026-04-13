import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/models/cart_model.dart';
import 'package:vertecueilletteapp/providers/cart_provider.dart';
import 'package:vertecueilletteapp/theme/app_colors.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  String money(double value) =>
      '${value.toStringAsFixed(2).replaceAll('.', ',')} €';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final mode = ref.watch(serviceModeProvider);

    return Scaffold(
      body: SafeArea(
        child: cartAsync.when(
          data: (cart) {
            final lignes = cart?.lignes ?? [];
            final double subtotal = cart?.totalPanier ?? 0.0;
            final double remise =
                mode == ServiceMode.autoCueillette ? subtotal * 0.15 : 0.0;
            final double totalAffiche = subtotal - remise;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back, size: 28),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Panier',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'MODE DE SERVICE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF5EC),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _modeButton(
                            label: 'Auto-cueillette',
                            selected: mode == ServiceMode.autoCueillette,
                            icon: Icons.eco_outlined,
                            onTap: () => ref
                                .read(serviceModeProvider.notifier)
                                .setMode(ServiceMode.autoCueillette),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _modeButton(
                            label: 'Emballé',
                            selected: mode == ServiceMode.emballe,
                            icon: Icons.inventory_2_outlined,
                            onTap: () => ref
                                .read(serviceModeProvider.notifier)
                                .setMode(ServiceMode.emballe),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      const Text(
                        'Vos articles',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${lignes.length} articles',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (lignes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text(
                          'Votre panier est vide.',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ),
                    )
                  else
                    ...lignes.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _cartItem(context, ref, line),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F8EE),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: const Color(0xFFD4EBCF)),
                    ),
                    child: Column(
                      children: [
                        _priceRow(
                          'Sous-total',
                          money(subtotal),
                          const Color(0xFF66758A),
                        ),
                        const SizedBox(height: 10),
                        _priceRow(
                          'Remise (${mode == ServiceMode.autoCueillette ? 'Cueillette' : 'Emballé'})',
                          '- ${money(remise)}',
                          AppColors.primary,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Divider(),
                        ),
                        _priceRow(
                          'Total',
                          money(totalAffiche < 0 ? 0.0 : totalAffiche),
                          AppColors.primary,
                          bold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: lignes.isEmpty
                          ? null
                          : () async {
                              try {
                                final reservation = await ref
                                    .read(cartProvider.notifier)
                                    .checkout();

                                if (!context.mounted) return;
                                context.push(
                                  '/reservation-success',
                                  extra: reservation,
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Erreur checkout : $e'),
                                  ),
                                );
                              }
                            },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirmer la Réservation',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.check_circle_outline),
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

  Widget _modeButton({
    required String label,
    required bool selected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 74,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : const Color(0xFF66758A),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF66758A),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartItem(BuildContext context, WidgetRef ref, CartLineModel line) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFEEF1EE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Image.network(
              line.imageUrl,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 92,
                height: 92,
                color: const Color(0xFFF2F4F3),
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.nomProduit,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${line.prixUnitaire.toStringAsFixed(2).replaceAll('.', ',')} € / unité',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      light: true,
                      onTap: () =>
                          ref.read(cartProvider.notifier).decrement(line),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      '${line.quantite}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 14),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () =>
                          ref.read(cartProvider.notifier).increment(line),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => ref.read(cartProvider.notifier).remove(line),
                icon: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFF98A4BA),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                money(line.sousTotal),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({
    required IconData icon,
    bool light = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: light ? const Color(0xFFE8F4E5) : AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: light ? AppColors.primary : Colors.white,
        ),
      ),
    );
  }

  Widget _priceRow(
    String title,
    String value,
    Color valueColor, {
    bool bold = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 20 : 16,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
            color: bold ? AppColors.dark : const Color(0xFF66758A),
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 22 : 16,
            fontWeight: FontWeight.w800,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}