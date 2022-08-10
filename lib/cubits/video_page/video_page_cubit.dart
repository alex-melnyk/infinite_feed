import 'dart:developer' as developer;
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:infinite_feed/data/models/models.dart';
import 'package:video_player/video_player.dart';

part 'video_page_state.dart';

class VideoPageCubit extends Cubit<VideoPageState> {
  VideoPageCubit(Video video)
      : super(
          VideoPageState(
            video: video,
            isPlayable: video.filePath != null,
          ),
        );

  static const kTag = 'VideoPageCubit';

  bool get isVisibleFully => state.visibleFraction == 1.0;

  bool get isVisibleTopPart => state.visibleFraction >= 0.85;

  bool get isVisibleBottomPart => state.visibleFraction <= 0.15;

  /// Sets the state [VideoPageState.isVisible] value.
  void updateVisibleFraction(double value) {
    emit(
      state.copyWith(
        visibleFraction: value,
      ),
    );
  }

  /// Updates the video instance.
  void updateVideo(Video video) {
    developer.log('$kTag Update the video ${video.id}');
    emit(
      state.copyWith(
        video: video,
        isPlayable: video.filePath != null,
      ),
    );
  }

  /// Returns true if controller already playing.
  bool get isPlaying => state.controller?.value.isPlaying ?? false;

  /// Initializes the local video if it is playable.
  Future<void> initialize() async {
    developer.log('$kTag Initialize video ${state.video.id}');
    if (!state.isPlayable) {
      developer.log('$kTag Video is not playable yet');
      return;
    }

    if (state.isInitialized) {
      developer.log('$kTag Disposing previous video');
      await state.controller?.dispose();

      emit(
        state.copyWith(
          controller: const Optional.empty(),
          isInitialized: false,
        ),
      );
    }

    try {
      developer.log('$kTag Create controller for ${state.video.filePath}');
      final controller = VideoPlayerController.file(
        File(state.video.filePath!),
      )..setLooping(true);

      developer.log('$kTag Initialize controller...');
      await controller.initialize();

      emit(
        state.copyWith(
          controller: Optional(controller),
          isInitialized: controller.value.isInitialized,
        ),
      );

      if (isVisibleFully) {
        developer.log(
            '$kTag Video page fully visible, so start playing immediately');
        await controller.play();
      }
    } catch (e, st) {
      developer.log(
        '$kTag Error while initialize the video controller',
        error: e,
        stackTrace: st,
      );
    }
  }

  /// Start playing video if it is initialized and not playing yet.
  Future<void> play() async {
    developer.log('$kTag Play video');

    if (!state.isInitialized) {
      developer.log('$kTag Controller is not initialized');
    } else if (isPlaying) {
      developer.log('$kTag Video playing now');
      return;
    }

    developer.log('$kTag Playing video');
    await state.controller!.play();
  }

  /// Pause video if it is initialized and playing.
  Future<void> pause() async {
    developer.log('$kTag Pause video');

    if (!state.isInitialized) {
      developer.log('$kTag Controller is not initialized');
    } else if (!isPlaying) {
      developer.log('$kTag Video is not playing');
      return;
    }

    developer.log('$kTag Pausing video');
    await state.controller!.pause();
  }

  @override
  Future<void> close() async {
    developer.log(
      '$kTag Cubit is closing for the video ${state.video.id}, '
      'disposing the controller...',
    );
    await state.controller?.dispose();

    return super.close();
  }
}
