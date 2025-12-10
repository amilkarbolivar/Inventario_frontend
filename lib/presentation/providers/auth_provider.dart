import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/auth_response_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  AuthResponseModel? _authResponse;
  bool _isLoading = false;
  String? _errorMessage;
  
  AuthResponseModel? get authResponse => _authResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authResponse != null;
  
  Future<bool> login(String correo, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _authResponse = await _authService.login(correo, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  void logout() {
    _authService.logout();
    _authResponse = null;
    notifyListeners();
  }
}