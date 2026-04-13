import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';
import 'package:vertecueilletteapp/theme/app_colors.dart';

class ReservationSuccessScreen extends StatelessWidget {
  final ReservationModel reservation;

  const ReservationSuccessScreen({
    super.key,
    required this.reservation,
  });

  String money(double value) => '${value.toStringAsFixed(2).replaceAll('.', ',')} €';

  @override
  Widget build(BuildContext context) {
    final qrUrl = '${ApiClient.baseUrl}/reservations/${reservation.idReservation}/qrcode';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        'Réservation confirmée',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                width: 94,
                height: 94,
                decoration: const BoxDecoration(
                  color: Color(0xFFD9F3D3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 54,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Votre réservation est prête !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              const Text(
                'Montrez ce QR code à l’accueil au moment du retrait.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.textGrey),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFE4F1DE)),
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.network(
                        qrUrl,
                        headers: {
                          if (SessionManager.token != null)
                            HttpHeaders.authorizationHeader: 'Bearer ${SessionManager.token}',
                        },
                        width: 220,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 220,
                          height: 220,
                          color: const Color(0xFFF3F5F3),
                          child: const Icon(Icons.qr_code_2, size: 80),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'RESERVATION ID',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        color: Color(0xFF98A4BA),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '#RES-${reservation.idReservation}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              _detailCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Articles réservés',
                subtitle: reservation.lignes.map((e) => e.nomProduit).join(', '),
                trailing: '${reservation.lignes.length} items',
              ),
              const SizedBox(height: 14),
              _detailCard(
                icon: Icons.local_shipping_outlined,
                title: 'Mode de retrait',
                subtitle: 'Retrait à la ferme',
                trailing: reservation.statut,
              ),
              const SizedBox(height: 14),
              _detailCard(
                icon: Icons.payments_outlined,
                title: 'Montant total',
                subtitle: '${reservation.dateReservation} • ${reservation.heureReservation}',
                trailing: money(reservation.totalCommande),
                trailingColor: AppColors.primary,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 62,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.home_outlined),
                  label: const Text(
                    'Retour à l’accueil',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailing,
    Color trailingColor = AppColors.dark,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: AppColors.primary, size: 34),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: AppColors.textGrey, fontSize: 15)),
              ],
            ),
          ),
          Text(
            trailing,
            style: TextStyle(
              color: trailingColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}