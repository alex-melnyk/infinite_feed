import 'dart:io';

import 'package:infinite_feed/data/models/video.dart';
import 'package:infinite_feed/data/repository/base_repository.dart';

class ContentRepository extends BaseRepository {
  const ContentRepository(super.apiService);

  /// Request main feed videos from the server.
  ///
  /// Returns a list of [Video] when successfully downloaded, otherwise
  /// returns an empty list.
  Future<List<Video>> fetchVideoMainFeed() async {
    final data = await apiService.videosMainFeed();
    return List.of(data ?? []).cast<Map<String, dynamic>>()
        .map<Video>(Video.fromMap)
        .toList();
  }

  /// Downloads the [video] file to the local [file].
  ///
  /// Returns the copy of [video] with [Video.filePath] property
  /// when successfully downloaded, otherwise returns the [video] instance.
  Future<Video> downloadVideo({
    required Video video,
    required File file,
  }) async {
    await apiService.downloadFile(
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
