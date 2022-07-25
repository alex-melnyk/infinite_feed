import 'package:equatable/equatable.dart';

class ContentState extends Equatable {
  const ContentState({
    this.videoUrl = '',
    this.isInitialized = false,
    this.totalVideos = 0,
    this.currentIndex = 0,
  });

  final String videoUrl;
  final bool isInitialized;
  final int totalVideos;
  final int currentIndex;

  ContentState copyWith({
    String? videoUrl,
    bool? isInitialized,
    int? totalVideos,
    int? currentIndex,
  }) {
    return ContentState(
      videoUrl: videoUrl ?? this.videoUrl,
      isInitialized: isInitialized ?? this.isInitialized,
      totalVideos: totalVideos ?? this.totalVideos,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  @override
  List<Object> get props => [
        videoUrl,
        isInitialized,
        totalVideos,
        currentIndex,
      ];
}
