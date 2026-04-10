import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../dio_client.dart';

class JwtInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  bool isRefreshing = false;

  JwtInterceptor(this.dio, this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Exclude auth routes from needing tokens
    if (!options.path.contains('/auth/login') && 
        !options.path.contains('/auth/register') &&
        !options.path.contains('/auth/otp')) {
      final accessToken = await secureStorage.read(key: 'access_token');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If getting 401 Unauthorized, and we have a refresh token
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      final refreshToken = await secureStorage.read(key: 'refresh_token');

      if (refreshToken != null) {
        if (!isRefreshing) {
          isRefreshing = true;

          try {
            // Create a new temporary Dio instance so we don't trigger the interceptor again
            final tokenDio = Dio(BaseOptions(baseUrl: DioClient.baseUrl));
            final response = await tokenDio.post(
              'auth/token/refresh/',
              data: {'refresh': refreshToken},
            );

            if (response.statusCode == 200) {
              final newAccessToken = response.data['access'];
              await secureStorage.write(key: 'access_token', value: newAccessToken);

              // Update the failed request with the new token
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              
              // Retry the specific request that failed
              final retryResponse = await dio.fetch(err.requestOptions);
              
              isRefreshing = false;
              return handler.resolve(retryResponse);
            }
          } catch (e) {
            // Refresh token is expired or invalid, log user out
            await secureStorage.deleteAll();
            // TODO: Route user to login screen via GetX or Router
          } finally {
            isRefreshing = false;
          }
        } else {
          // If a refresh is already in progress, ideally we should queue the request and wait.
          // For simplicity right now, we return the error.
        }
      } else {
        // No refresh token available, must log in
        await secureStorage.deleteAll();
      }
    }
    return super.onError(err, handler);
  }
}
