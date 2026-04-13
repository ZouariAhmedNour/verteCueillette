import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertecueilletteapp/api/panier_api.dart';
import 'package:vertecueilletteapp/models/cart_model.dart';
import 'package:vertecueilletteapp/models/reservation_model.dart';

final panierApiProvider = Provider<PanierApi>((ref) => PanierApi());

enum ServiceMode {
  autoCueillette,
  emballe,
}

class ServiceModeNotifier extends Notifier<ServiceMode> {
  @override
  ServiceMode build() {
    return ServiceMode.autoCueillette;
  }

  void setMode(ServiceMode mode) {
    state = mode;
  }
}

final serviceModeProvider =
    NotifierProvider<ServiceModeNotifier, ServiceMode>(
  ServiceModeNotifier.new,
);

class CartNotifier extends AsyncNotifier<CartModel?> {
  PanierApi get _api => ref.read(panierApiProvider);

  @override
  Future<CartModel?> build() async {
    return _api.getMyCart();
  }

  Future<void> refreshCart() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _api.getMyCart());
  }

  Future<void> addProduct(int idProduit) async {
    state = await AsyncValue.guard(
      () => _api.addToCart(
        idProduit: idProduit,
        quantite: 1,
      ),
    );
  }

  Future<void> increment(CartLineModel line) async {
    final cart = state.asData?.value;
    if (cart == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _api.updateLine(
        idPanier: cart.idPanier,
        idProduit: line.idProduit,
        quantite: line.quantite + 1,
      ),
    );
  }

  Future<void> decrement(CartLineModel line) async {
    final cart = state.asData?.value;
    if (cart == null) return;

    state = const AsyncLoading();

    if (line.quantite <= 1) {
      state = await AsyncValue.guard(
        () => _api.removeLine(
          idPanier: cart.idPanier,
          idProduit: line.idProduit,
        ),
      );
      return;
    }

    state = await AsyncValue.guard(
      () => _api.updateLine(
        idPanier: cart.idPanier,
        idProduit: line.idProduit,
        quantite: line.quantite - 1,
      ),
    );
  }

  Future<void> remove(CartLineModel line) async {
    final cart = state.asData?.value;
    if (cart == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _api.removeLine(
        idPanier: cart.idPanier,
        idProduit: line.idProduit,
      ),
    );
  }

  Future<ReservationModel> checkout() async {
    final cart = state.asData?.value;
    if (cart == null) {
      throw Exception('Panier vide');
    }

    final reservation = await _api.checkout(
      idPanier: cart.idPanier,
      dateReservation: DateTime.now().add(const Duration(days: 1, hours: 2)),
    );

    await refreshCart();
    return reservation;
  }
}

final cartProvider =
    AsyncNotifierProvider<CartNotifier, CartModel?>(
  CartNotifier.new,
);

final cartItemsCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider).asData?.value;
  if (cart == null) return 0;

  return cart.lignes.fold<int>(0, (sum, item) => sum + item.quantite);
});