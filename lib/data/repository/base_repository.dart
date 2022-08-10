import 'package:infinite_feed/api/api_helper.dart';

/// Base repository class.
abstract class BaseRepository {
  const BaseRepository(this.apiService);

  final ApiHelper apiService;
}
