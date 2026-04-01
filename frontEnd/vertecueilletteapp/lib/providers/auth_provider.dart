import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../api/auth_api.dart';

final authApiProvider = Provider((ref) => AuthApi());

final authLoadingProvider = StateProvider<bool>((ref) => false);

final authTokenProvider = StateProvider<String?>((ref) => null);