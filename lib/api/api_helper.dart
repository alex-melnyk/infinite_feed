import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:infinite_feed/utils/device_info.dart';

class ApiHelper {
  final _baseUrl = 'https://api.claps.ai/v1';

  Future<dynamic> checkAuth() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/health-check-auth'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Device-Id': DeviceInfo.deviceId ?? ''
    });
    return response;
  }

  Future<dynamic> getVideos() async {
    final response =
        await http.get(Uri.parse('$_baseUrl/videos/main-feed'), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Device-Id': DeviceInfo.deviceId ?? ''
    });
    return response;
  }
}
