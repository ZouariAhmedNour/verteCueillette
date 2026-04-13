import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';

class ReservationApi {
  Future<List<ReservationModel>> getMyReservations() async {
    final userId = SessionManager.userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await ApiClient.get('/reservations/user/$userId');
    final data = response.data;

    if (data is! List) {
      throw Exception('Format invalide pour les réservations.');
    }

    return data
        .map((e) => ReservationModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}