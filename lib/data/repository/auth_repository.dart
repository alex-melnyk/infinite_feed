import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/data/model/auth_check.dart';

class AuthRepository {
  const AuthRepository(this._apiService);

  final ApiHelper _apiService;

  Future<AuthCheck> checkAuth() async {
    final data = await _apiService.checkAuth();
    return AuthCheck.fromMap(data);
  }
}
