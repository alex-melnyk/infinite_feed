import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/cubits/cubits.dart';
import 'package:infinite_feed/data/models/video.dart';
import 'package:infinite_feed/presentation/widgets/widgets.dart';
import 'package:infinite_feed/utils/duration_extension.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'dart:developer' as developer;

class VideoPage extends StatefulWidget {
  const VideoPage({
    Key? key,
    required this.video,
  }) : super(key: key);

  final Video video;

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  static const kTag = 'VideoPageWidget';
  static const _backgroundDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 5,
        color: Colors.black,
      ),
    ),
  );
  final _visibilityKey = GlobalKey();
  late final VideoPageCubit videoPageCubit;

  @override
  void initState() {
    super.initState();

    videoPageCubit = VideoPageCubit(widget.video)..initialize();
  }

  @override
  void didUpdateWidget(covariant VideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video != widget.video) {
      videoPageCubit
        ..updateVideo(widget.video)
        ..initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => videoPageCubit,
      child: DecoratedBox(
        decoration: _backgroundDecoration,
        child: VisibilityDetector(
          key: _visibilityKey,
          onVisibilityChanged: _handleVisibilityChanged,
          child: BlocBuilder<VideoPageCubit, VideoPageState>(
            builder: (context, state) {
              if (!state.isInitialized) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final controller = state.controller!;

              return Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: _handleTogglePlayPressed,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: controller,
                      builder: (_, value, __) {
                        return VideoProgress(
                          value: value.position / value.duration,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _handleVisibilityChanged(VisibilityInfo info) async {
    if (!mounted) {
      return;
    }

    developer.log('$kTag visibility: ${info.visibleFraction}');

    videoPageCubit.updateVisibleFraction(info.visibleFraction);

    if (!videoPageCubit.state.isInitialized) {
      developer.log('$kTag video is not initialized yet');
      return;
    }

    developer.log('$kTag video visible at top part');

    if (videoPageCubit.isVisibleTopPart) {
      developer.log('$kTag video visible at top part');
      await videoPageCubit.play();
    } else if (videoPageCubit.isVisibleBottomPart) {
      developer.log('$kTag video visible at bottom part');
      await videoPageCubit.pause();
    }
  }

  void _handleTogglePlayPressed() async {
    if (!mounted && !videoPageCubit.state.isInitialized) {
      return;
    }

    if (videoPageCubit.isPlaying) {
      await videoPageCubit.pause();
    } else {
      await videoPageCubit.play();
    }
  }
}
