import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/bloc/content_bloc/content_event.dart';
import 'package:infinite_feed/bloc/content_bloc/content_state.dart';
import 'package:infinite_feed/data/model/video.dart';
import 'package:infinite_feed/data/repository/auth_repository.dart';
import 'package:infinite_feed/data/repository/content_repository.dart';
import 'package:video_player/video_player.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final AuthRepository _authRepository;
  final ContentRepository _contentRepository;
  final List<Video> _videos = [];
  VideoPlayerController? _videoController;
  VideoPlayerController? _nextVideoController;
  VideoPlayerController? _previousVideoController;

  VideoPlayerController? get videoController => _videoController;

  ContentBloc(
    this._authRepository,
    this._contentRepository,
  ) : super(const ContentState()) {
    on<ContentEvent>((event, emit) async {
      try {
        if (event is InitialContentRequested) {
          _onInitialContentRequested();
        } else if (event is InitialContentLoaded) {
          emit(state.copyWith(
            videoUrl: _videos[state.currentIndex].url,
            totalVideos: _videos.length,
          ));
          _onInitialContentLoaded();
        }
        if (event is ContentRequested) {
          _onContentRequested();
          emit(state.copyWith(
            totalVideos: _videos.length,
          ));
        } else if (event is SwipeUp) {
          emit(state.copyWith(currentIndex: state.currentIndex + 1));
          emit(state.copyWith(
            videoUrl: _videos[state.currentIndex].url,
          ));
          _onSwipeUp();
        } else if (event is SwipeDown) {
          emit(state.copyWith(currentIndex: state.currentIndex - 1));
          emit(state.copyWith(
            videoUrl: _videos[state.currentIndex].url,
          ));
          _onSwipeDown();
        } else if (event is ContentInitialized) {
          emit(state.copyWith(isInitialized: true));
          videoController!.play();
        }
      } catch (e, s) {
        print(e);
        print(s);
      }
    });
  }

  _onInitialContentRequested() async {
    final status = await _authRepository.checkAuth();
    if (status.message.toLowerCase() == 'ok') {
      final items = await _contentRepository.loadVideos();
      _videos.addAll(items);
      add(InitialContentLoaded());
    }
  }

  _onInitialContentLoaded() async {
    _videoController = VideoPlayerController.network(state.videoUrl)
      ..initialize().then((value) => add(ContentInitialized()));
    _nextVideoController =
        VideoPlayerController.network(_videos[state.currentIndex + 1].url!)
          ..initialize();
  }

  _onContentRequested() async {
    final status = await _authRepository.checkAuth();
    if (status.message.toLowerCase() == 'ok') {
      final items = await _contentRepository.loadVideos();
      _videos.addAll(items);
    }
  }

  _onSwipeUp() {
    _videoController = _nextVideoController;
    _videoController?.play();
    _nextVideoController =
        VideoPlayerController.network(_videos[state.currentIndex + 1].url!)
          ..initialize();
    _previousVideoController =
        VideoPlayerController.network(_videos[state.currentIndex - 1].url!)
          ..initialize();
    if (state.currentIndex == state.totalVideos - 4) {
      add(ContentRequested());
    }
  }

  _onSwipeDown() {
    _nextVideoController = _videoController;
    _videoController = _previousVideoController;
    _videoController?.play();
    if (state.currentIndex > 0) {
      _previousVideoController =
          VideoPlayerController.network(_videos[state.currentIndex - 1].url!)
            ..initialize();
    }
  }
}
