import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';
import 'package:vertecueilletteapp/providers/reservation_provider.dart';
import 'package:vertecueilletteapp/theme/app_colors.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  bool isUpcoming(String statut) {
    return statut == 'EN_ATTENTE' ||
        statut == 'CONFIRMEE' ||
        statut == 'PREPAREE';
  }

  String money(double value) =>
      '${value.toStringAsFixed(2).replaceAll('.', ',')} €';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(myReservationsProvider);

    return Scaffold(
      body: SafeArea(
        child: reservationsAsync.when(
          data: (items) {
            final upcoming = items.where((e) => isUpcoming(e.statut)).toList();
            final past = items.where((e) => !isUpcoming(e.statut)).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Collections',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Keep track of your fresh farm reservations and past harvests.',
                    style:
                        TextStyle(fontSize: 16, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.primary),
                      const SizedBox(width: 10),
                      const Text(
                        'Upcoming',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F7DF),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          '${upcoming.length} ACTIVE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (upcoming.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Aucune réservation en cours.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    )
                  else
                    ...upcoming.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _reservationCard(context, item, active: true),
                      ),
                    ),
                  const SizedBox(height: 18),
                  const Row(
                    children: [
                      Icon(Icons.history, color: Color(0xFF98A4BA)),
                      SizedBox(width: 10),
                      Text(
                        'Past Orders',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (past.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Text(
                        'Aucune ancienne commande.',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    )
                  else
                    ...past.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _pastTile(item),
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

  Widget _reservationCard(BuildContext context, ReservationModel item,
      {required bool active}) {
    final statusColor = item.statut == 'PREPAREE'
        ? Colors.orange
        : item.statut == 'CONFIRMEE'
            ? AppColors.primary
            : const Color(0xFF6E7C91);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFDCEFD6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.statut,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.lignes.map((e) => e.nomProduit).join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                money(item.totalCommande),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${item.dateReservation} • ${item.heureReservation}',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 16),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Divider(),
          ),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppColors.textGrey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.statut == 'PREPAREE'
                      ? 'Prête au retrait'
                      : 'En préparation',
                  style:
                      const TextStyle(color: AppColors.textGrey, fontSize: 16),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: item.statut == 'PREPAREE'
                      ? const Color(0xFFE5F6DE)
                      : AppColors.primary,
                  foregroundColor: item.statut == 'PREPAREE'
                      ? const Color(0xFF1E6A12)
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () =>
                    context.push('/reservation-success', extra: item),
                child: Text(item.statut == 'PREPAREE' ? 'Show QR' : 'Details'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _pastTile(ReservationModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.lignes.map((e) => e.nomProduit).join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.dateReservation} • ${item.lignes.length} items',
                  style: const TextStyle(color: AppColors.textGrey),
                ),
                const SizedBox(height: 6),
                Text(
                  item.statut,
                  style: const TextStyle(
                    color: Color(0xFF92A0B5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            money(item.totalCommande),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}