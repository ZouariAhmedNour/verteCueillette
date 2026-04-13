import 'package:vertecueilletteapp/api/api_client.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import 'package:vertecueilletteapp/models/cart_model.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';

class PanierApi {
  Future<CartModel> getMyCart() async {
    final userId = SessionManager.userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await ApiClient.get('/paniers/user/$userId');
    return CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<CartModel> addToCart({
    required int idProduit,
    int quantite = 1,
  }) async {
    final userId = SessionManager.userId;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final response = await ApiClient.post(
      '/paniers/add',
      data: {
        'idUser': userId,
        'idProduit': idProduit,
        'quantite': quantite,
      },
    );

    return CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<CartModel> updateLine({
    required int idPanier,
    required int idProduit,
    required int quantite,
  }) async {
    final response = await ApiClient.put(
      '/paniers/$idPanier/produits/$idProduit',
      data: {'quantite': quantite},
    );

    return CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<CartModel> removeLine({
    required int idPanier,
    required int idProduit,
  }) async {
    final response = await ApiClient.dio.delete('/paniers/$idPanier/produits/$idProduit');
    ApiClient.dio.options.validateStatus = (status) => status != null && status < 600;
    return CartModel.fromJson(Map<String, dynamic>.from(response.data as Map));
  }

  Future<ReservationModel> checkout({
    required int idPanier,
    required DateTime dateReservation,
  }) async {
    final hh = dateReservation.hour.toString().padLeft(2, '0');
    final mm = dateReservation.minute.toString().padLeft(2, '0');

    final response = await ApiClient.post(
      '/paniers/$idPanier/checkout',
      data: {
        'dateReservation': dateReservation.toIso8601String().split('T').first,
        'heureReservation': '$hh:$mm:00',
      },
    );

    return ReservationModel.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}