import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/user_api.dart';
import '../models/user_model.dart';

final userApiProvider = Provider((ref) => UserApi());

final profileProvider = FutureProvider<UserModel>((ref) async {
  final api = ref.read(userApiProvider);

   return await api.getUserById(1);
});