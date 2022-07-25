import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/cubits/status.dart';
import 'package:infinite_feed/data/model/video.dart';
import 'package:infinite_feed/data/repository/auth_repository.dart';
import 'package:infinite_feed/data/repository/content_repository.dart';
import 'package:infinite_feed/utils/device_info.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'feed_state.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit()
      : _apiHelper = ApiHelper(),
        super(const FeedState.initial()) {
    _authRepository = AuthRepository(_apiHelper);
    _contentRepository = ContentRepository(_apiHelper);
  }

  static const _preloadAmount = 7;
  static final Map<String, Completer<void>> _downloads = {};
  late final ApiHelper _apiHelper;
  late final AuthRepository _authRepository;
  late final ContentRepository _contentRepository;
  late final Directory _temporaryDir;

  void init() async {
    _temporaryDir = await getTemporaryDirectory();

    try {
      final status = await _authRepository.checkAuth();

      if (status.message.toLowerCase() != 'ok') {
        return;
      }
    } catch (e, st) {
      emit(state.copyWith(status: Status.failure));
      developer.log(
        'Failed to check server status',
        error: e,
        stackTrace: st,
      );
    }
  }

  Future<void> loadMore({
    bool forceLoadVideos = false,
  }) async {
    emit(state.copyWith(status: Status.request));

    try {
      final videoFeed = await _contentRepository.fetchVideos();

      emit(
        state.copyWith(
          status: Status.success,
          videos: [...state.videos, ...videoFeed],
        ),
      );

      if (forceLoadVideos) {
        moveTo(0);
      }
    } catch (e, st) {
      emit(state.copyWith(status: Status.failure));
      developer.log(
        'Failed to load video feed',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Sets the [FeedState.videoIndex], calculate how much videos
  /// needs to be downloaded, and schedules the download.
  void moveTo(int videoIndex) async {
    final loadMoreIsNeeded = videoIndex + _preloadAmount > state.videos.length;

    if (loadMoreIsNeeded) {
      await loadMore();
    }

    final downloadList = state.videos
        .sublist(videoIndex, videoIndex + _preloadAmount)
        .where((e) => e.filePath == null && !_downloads.containsKey(e.url));

    for (final item in downloadList) {
      _downloads[item.url] = Completer()..complete(_downloadVideo(item));
    }

    emit(state.copyWith(currentVideo: videoIndex));
  }

  /// Downloads the [video] by [video.url] and update the state
  /// when the video is downloaded.
  Future<void> _downloadVideo(Video video) async {
    try {
      final downloadedVideo = await _contentRepository.downloadVideo(
        video: video,
        file: File(join(_temporaryDir.path, DeviceInfo.uuid.v4())),
      );

      final videoIndex =
          state.videos.indexWhere((e) => e.id == downloadedVideo.id);

      emit(
        state.copyWith(
          status: Status.success,
          videos: [...state.videos]..[videoIndex] = downloadedVideo,
        ),
      );

      _downloads.remove(video.url);
    } catch (e, st) {
      developer.log(
        'Failed to load video "${video.url}"',
        error: e,
        stackTrace: st,
      );
    }
  }
}
