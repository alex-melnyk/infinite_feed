import 'dart:io';

import 'package:flutter/material.dart';
import 'package:infinite_feed/data/model/video.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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
  static const _backgroundDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 5,
        color: Colors.black,
      ),
    ),
  );
  final _visibilityKey = GlobalKey();
  bool _isVisible = false;
  VideoPlayerController? _videoPlayerController;
  Future<void>? _initializeFuture;

  @override
  void initState() {
    super.initState();

    _initializeVideo();
  }

  @override
  void didUpdateWidget(covariant VideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video != widget.video) {
      _initializeVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: _backgroundDecoration,
      child: VisibilityDetector(
        key: _visibilityKey,
        onVisibilityChanged: _handleVisibilityChanged,
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onTap: _handleTogglePlayPressed,
              child: FutureBuilder(
                future: _initializeFuture,
                builder: (context, snapshot) {
                  print(snapshot);

                  if (_videoPlayerController == null ||
                      snapshot.connectionState != ConnectionState.done) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: VideoPlayer(_videoPlayerController!),
                  );
                },
              ),
            ),
            if (_videoPlayerController != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.maxFinite,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                  ),
                  child: ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _videoPlayerController!,
                    builder: (_, value, __) {
                      final diff = value.position.inMilliseconds /
                          value.duration.inMilliseconds;

                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: diff.isNaN ? 0.0 : diff,
                        heightFactor: 1.0,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();

    super.dispose();
  }

  void _initializeVideo() {
    if (!mounted) {
      return;
    }

    if (widget.video.filePath == null) {
      return;
    }

    if (_videoPlayerController == null) {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.video.filePath!))
            ..setLooping(true);
      _initializeFuture = _videoPlayerController!.initialize();
    }

    if (_isVisible && !_videoPlayerController!.value.isPlaying) {
      _videoPlayerController!.play();
    }
  }

  void _handleVisibilityChanged(VisibilityInfo info) async {
    if (!mounted) {
      return;
    }

    _isVisible = info.visibleFraction == 1.0;

    if (_videoPlayerController == null || _initializeFuture == null) {
      return;
    }

    if (info.visibleFraction >= 0.85 &&
        !(_videoPlayerController?.value.isPlaying ?? false)) {
      await _initializeFuture;
      await _videoPlayerController?.play();
    } else if (info.visibleFraction <= 0.15 &&
        _videoPlayerController!.value.isPlaying) {
      await _videoPlayerController?.pause();
    }
  }

  void _handleTogglePlayPressed() async {
    if (!mounted) {
      return;
    }

    final isInitialized = _videoPlayerController?.value.isInitialized ?? false;

    if (!isInitialized) {
      return;
    }

    if (_videoPlayerController!.value.isPlaying) {
      await _videoPlayerController!.pause();
    } else {
      await _videoPlayerController!.play();
    }
  }
}
