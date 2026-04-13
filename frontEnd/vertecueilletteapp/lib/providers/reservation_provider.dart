import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertecueilletteapp/api/reservation_api.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';

final reservationApiProvider = Provider((ref) => ReservationApi());

final myReservationsProvider = FutureProvider<List<ReservationModel>>((ref) async {
  final api = ref.read(reservationApiProvider);
  return api.getMyReservations();
});