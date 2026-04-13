import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vertecueilletteapp/api/session_manager.dart';
import '../api/user_api.dart';
import '../models/user_model.dart';

final userApiProvider = Provider((ref) => UserApi());

final profileProvider = FutureProvider<UserModel>((ref) async {
  final api = ref.read(userApiProvider);
  final userId = SessionManager.userId;

   if (userId == null) {
    throw Exception('Utilisateur non connecté');
  }

   return await api.getUserById(userId);
});