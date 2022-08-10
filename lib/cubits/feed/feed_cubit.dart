import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/cubits/status.dart';
import 'package:infinite_feed/data/models/video.dart';
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

  /// Initialize temporary directory and checks the server status,
  /// then loads a first page of main feed.
  Future<void> init() async {
    _temporaryDir = await getTemporaryDirectory();

    try {
      developer.log('Checking health status...');
      final status = await _authRepository.heathCheckAuth();
      developer.log('Health status is ok? $status');

      emit(state.copyWith(healthCheckAuth: status));
    } catch (e, st) {
      emit(
        state.copyWith(
          status: Status.failure,
          healthCheckAuth: false,
        ),
      );
      developer.log(
        'Failed to check server status',
        error: e,
        stackTrace: st,
      );
    }

    await loadMore(forceLoadVideos: true);
  }

  /// Force reload the main feed.
  Future<void> refresh() {
    emit(state.copyWith(status: Status.request));

    return loadMore(forceLoadVideos: true);
  }

  /// Loads more videos from main feed.
  /// When the parameter [forceLoadVideos] is true, state videos will be
  /// replaced with next main feed videos.
  Future<void> loadMore({
    bool forceLoadVideos = false,
  }) async {
    developer.log('Loading more with force? $forceLoadVideos');
    emit(state.copyWith(status: Status.request));

    try {
      final videoFeed = await _contentRepository.fetchVideoMainFeed();
      developer.log('Loaded feed length ${videoFeed.length}');

      emit(
        state.copyWith(
          status: Status.success,
          videos: forceLoadVideos ? videoFeed : [...state.videos, ...videoFeed],
        ),
      );

      if (forceLoadVideos) {
        developer.log('Forcing load videos');
        await moveTo(0);
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
  Future<void> moveTo(int pageIndex) async {
    developer.log('Move to page $pageIndex');
    final loadMoreIsNeeded = pageIndex + _preloadAmount > state.videos.length;

    if (loadMoreIsNeeded) {
      developer.log('Requesting more videos');
      await loadMore();
    }

    final downloadList = state.videos
        .sublist(pageIndex, pageIndex + _preloadAmount)
        .where((e) => e.filePath == null && !_downloads.containsKey(e.url));

    developer.log('Plan to download videos amount: ${downloadList.length}');
    for (final item in downloadList) {
      _downloads[item.url] = Completer()..complete(_downloadVideo(item));
    }

    emit(state.copyWith(currentVideo: pageIndex));

    if (_downloads.values.isNotEmpty) {
      developer.log('Waiting for the first video download...');
      await _downloads.values.first.future;
      developer.log('The first video downloaded');
    }
  }

  /// Downloads the [video] by [video.url] and update the state
  /// when the video is downloaded.
  Future<void> _downloadVideo(Video video) async {
    developer.log('Trying to download video ${video.id}');

    try {
      final fileUuid = DeviceInfo.uuid.v4();
      final downloadedVideo = await _contentRepository.downloadVideo(
        video: video,
        file: File(join(_temporaryDir.path, '$fileUuid.mp4')),
      );
      developer.log(
        'Video ${video.id} is downloaded at '
        '${downloadedVideo.filePath}',
      );

      final videoIndex =
          state.videos.indexWhere((e) => e.id == downloadedVideo.id);

      emit(
        state.copyWith(
          status: Status.success,
          videos: [...state.videos]..[videoIndex] = downloadedVideo,
        ),
      );
    } catch (e, st) {
      developer.log(
        'Failed to load video ${video.id} by url "${video.url}"',
        error: e,
        stackTrace: st,
      );
    } finally {
      _downloads.remove(video.url);
    }
  }
}
