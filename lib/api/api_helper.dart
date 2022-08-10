import 'package:dio/dio.dart';
import 'package:infinite_feed/utils/device_info.dart';
import 'package:path/path.dart';

class ApiHelper {
  static const _baseUrl = 'https://api.claps.ai/v1';

  static final _client = Dio(
    BaseOptions(
      headers: {
        'Device-Id': DeviceInfo.deviceId,
      },
    ),
  );

  Future<dynamic> healthCheckAuth() async {
    final resp = await _client.get(join(_baseUrl, 'health-check-auth'));
    return resp.data;
  }

  Future<List?> videosMainFeed() async {
    final resp = await _client.get(join(_baseUrl, 'videos/main-feed'));
    return resp.data;
  }

  /// Downloads the file by [url] to the local [filePath].
  Future<void> downloadFile(
    String url, {
    required String filePath,
  }) {
    return _client.download(url, filePath);
  }
}
