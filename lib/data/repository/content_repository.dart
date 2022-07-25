import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/data/model/video.dart';
import 'dart:convert';

class ContentRepository {
  final ApiHelper _apiService;

  ContentRepository(this._apiService);

  Future<List<Video>> loadVideos() async {
    final response = await _apiService.getVideos();
    final List decoded = jsonDecode(response.body);
    final List<Video> videos =
        decoded.map((item) => Video.fromMap(item)).toList();
    return videos;
  }
}
