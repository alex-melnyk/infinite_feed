import 'package:dio/dio.dart';
import 'package:infinite_feed/utils/device_info.dart';
import 'package:path/path.dart';

class ApiHelper {
  static const _baseUrl = 'https://api.claps.ai/v1';
  static final client = Dio(
    BaseOptions(
      headers: {
        'Device-Id': DeviceInfo.deviceId,
      },
    ),
  );

  Future<dynamic> checkAuth() async {
    final resp = await client.get(join(_baseUrl, 'health-check-auth'));
    return resp.data;
  }

  Future<dynamic> getVideos() async {
    final resp = await client.get(join(_baseUrl, 'videos/main-feed'));
    return resp.data;
  }

  Future<void> downloadFile(
    String url, {
    required String filePath,
  }) {
    return client.download(url, filePath);
  }
}
