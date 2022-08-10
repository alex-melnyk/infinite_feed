part of 'video_page_cubit.dart';

class VideoPageState extends Equatable {
  const VideoPageState({
    required this.video,
    this.isInitialized = false,
    this.isPlayable = false,
    this.visibleFraction = 0.0,
    this.controller,
  });

  final Video video;
  final bool isInitialized;
  final bool isPlayable;
  final double visibleFraction;
  final VideoPlayerController? controller;

  @override
  List<Object?> get props => [
        video,
        isInitialized,
        isPlayable,
        visibleFraction,
        controller,
      ];

  VideoPageState copyWith({
    Video? video,
    bool? isInitialized,
    bool? isPlayable,
    double? visibleFraction,
    Optional<VideoPlayerController?>? controller,
  }) {
    return VideoPageState(
      video: video ?? this.video,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlayable: isPlayable ?? this.isPlayable,
      visibleFraction: visibleFraction ?? this.visibleFraction,
      controller: controller == null ? this.controller : controller.value,
    );
  }
}
