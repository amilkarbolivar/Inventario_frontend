import '../../core/network/api_client.dart';
import '../../core/constants/api_endpoints.dart';
import '../models/auth_response_model.dart';

class AuthService {
  final ApiClient _client = ApiClient();
  
  Future<AuthResponseModel> login(String correo, String password) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {
          'correo': correo,
          'password': password,
        },
      );
      
      final authResponse = AuthResponseModel.fromJson(response.data);
      _client.setToken(authResponse.token);
      
      return authResponse;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }
  
  void logout() {
    _client.clearToken();
  }
}
