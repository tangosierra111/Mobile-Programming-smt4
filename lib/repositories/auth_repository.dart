import '../core/network/api_client.dart';
import '../models/auth_session.dart';

class AuthRepository {
  const AuthRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> sync({String? displayName}) async {
    final data = await _apiClient.post(
      '/auth/sync',
      body: {
        if (displayName != null && displayName.trim().isNotEmpty)
          'display_name': displayName.trim(),
      },
    );
    return AuthSession.fromJson(data as Map<String, dynamic>);
  }
}
