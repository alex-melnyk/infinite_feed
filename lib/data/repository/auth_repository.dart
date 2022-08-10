import 'package:infinite_feed/data/repository/base_repository.dart';

class AuthRepository extends BaseRepository {
  const AuthRepository(super.apiService);

  /// Health check auth.
  ///
  /// Returns true if it is "ok", otherwise false.
  Future<bool> heathCheckAuth() async {
    final data = await apiService.healthCheckAuth();

    if (data['message']?.toLowerCase() == 'ok') {
      return true;
    }

    return false;
  }
}
