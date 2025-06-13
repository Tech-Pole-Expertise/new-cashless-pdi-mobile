import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/web.dart';

class DioClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  DioClient._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://cashless-pdi.tpe.bf/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio = Dio(options);
    // Intercepteur pour logs et tokens
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = GetStorage().read('token');
          _logger.d('Token dans dio est : $token');
          if (options.extra['authRequired'] == true && token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          _logger.d('--> ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            '<-- ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.sendTimeout) {
            _logger.d("Timeout de connexion !");
          } else if (error.type == DioExceptionType.badCertificate ||
              error.type == DioExceptionType.badResponse) {
            _logger.d(
              "Problème avec la réponse du serveur : ${error.response?.statusCode}",
            );
          } else if (error.type == DioExceptionType.cancel) {
            _logger.d("Requête annulée");
          } else if (error.type == DioExceptionType.unknown) {
            _logger.d(
              "Pas de connexion Internet ou erreur inconnue : ${error.message}",
            );
          } else {
            _logger.d("Erreur Dio : ${error.message}");
          }
          _logger.d('Erreur : ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;
  // Méthodes pratiques
  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> post(String url, {dynamic data}) {
    return _dio.post(url, data: data);
  }

  Future<Response> put(String url, {dynamic data}) {
    return _dio.put(url, data: data);
  }

  Future<Response> delete(String url) {
    return _dio.delete(url);
  }
}
