import 'dart:io';

import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/data/model/video.dart';

class ContentRepository {
  const ContentRepository(this._apiService);

  final ApiHelper _apiService;

  Future<List<Video>> fetchVideos() async {
    final data = await _apiService.getVideos();
    return List.of(data).cast<Map<String, dynamic>>()
        .map<Video>(Video.fromMap)
        .toList();
  }

  Future<Video> downloadVideo({
    required Video video,
    required File file,
  }) async {
    await _apiService.downloadFile(
      video.url,
      filePath: file.path,
    );

    if (file.lengthSync() > 0) {
      return video.copyWith(
        filePath: file.path,
      );
    }

    return video;
  }
}
