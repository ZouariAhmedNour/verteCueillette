import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'session_manager.dart';

class ApiClient {
  // Téléphone physique sur le même Wi-Fi que le PC :
  static const String baseUrl = 'http://192.168.1.105:8080/api';

  // Si tu testes sur émulateur Android, remplace par :
  // static const String baseUrl = 'http://10.0.2.2:8080/api';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      validateStatus: (status) => status != null && status < 600,
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = SessionManager.token;
          if (token != null && token.isNotEmpty) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );

  static Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
      );
      _throwIfNeeded(response);
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  static Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      _throwIfNeeded(response);
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  static Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      _throwIfNeeded(response);
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  static void _throwIfNeeded(Response response) {
    final statusCode = response.statusCode ?? 0;

    if (statusCode >= 200 && statusCode < 300) {
      return;
    }

    throw ApiException(
      statusCode: statusCode,
      message: _extractMessage(response.data) ?? _defaultMessage(statusCode),
      data: response.data,
    );
  }

  static ApiException _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(message: 'Délai de connexion dépassé.');
      case DioExceptionType.sendTimeout:
        return ApiException(message: 'Délai d’envoi dépassé.');
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Délai de réception dépassé.');
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Impossible de joindre le serveur. Vérifie l’IP, le Wi-Fi, le port 8080 et que le backend tourne.',
        );
      case DioExceptionType.badCertificate:
        return ApiException(message: 'Certificat serveur invalide.');
      case DioExceptionType.cancel:
        return ApiException(message: 'Requête annulée.');
      case DioExceptionType.unknown:
        return ApiException(message: 'Erreur réseau inconnue.');
      case DioExceptionType.badResponse:
        final response = e.response;
        return ApiException(
          statusCode: response?.statusCode,
          message: _extractMessage(response?.data) ??
              _defaultMessage(response?.statusCode ?? 0),
          data: response?.data,
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    if (data is Map<String, dynamic>) {
      if (data['message'] is String && (data['message'] as String).trim().isNotEmpty) {
        return data['message'] as String;
      }
      if (data['error'] is String && (data['error'] as String).trim().isNotEmpty) {
        return data['error'] as String;
      }
      if (data['details'] is String && (data['details'] as String).trim().isNotEmpty) {
        return data['details'] as String;
      }
      if (data['title'] is String && (data['title'] as String).trim().isNotEmpty) {
        return data['title'] as String;
      }
      if (data['errors'] is List) {
        final errors = (data['errors'] as List).map((e) => e.toString()).join(', ');
        if (errors.isNotEmpty) return errors;
      }
    }

    return null;
  }

  static String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requête invalide.';
      case 401:
        return 'Non authentifié. Vérifie tes identifiants.';
      case 403:
        return 'Accès interdit.';
      case 404:
        return 'Ressource introuvable.';
      case 405:
        return 'Méthode HTTP non autorisée.';
      case 409:
        return 'Conflit de données.';
      case 415:
        return 'Type de contenu non supporté.';
      case 422:
        return 'Données invalides.';
      case 429:
        return 'Trop de requêtes.';
      case 500:
        return 'Erreur interne du serveur.';
      case 502:
        return 'Mauvaise passerelle.';
      case 503:
        return 'Service indisponible.';
      case 504:
        return 'Temps de réponse serveur dépassé.';
      default:
        return 'Erreur HTTP $statusCode.';
    }
  }
}