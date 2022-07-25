import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/data/model/auth_check.dart';

class AuthRepository {
  final ApiHelper _apiService;

  AuthRepository(this._apiService);

  Future<AuthCheck> checkAuth() async {
    final response = await _apiService.checkAuth();
    return AuthCheck.fromJson(response.body);
  }
}
