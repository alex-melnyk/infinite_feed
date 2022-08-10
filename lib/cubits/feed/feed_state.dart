part of 'feed_cubit.dart';

class FeedState extends Equatable {
  const FeedState._({
    this.status = Status.initial,
    this.healthCheckAuth = false,
    this.currentVideo = 0,
    this.videos = const [],
  });

  const FeedState.initial() : this._();

  final Status status;
  final bool healthCheckAuth;
  final int currentVideo;
  final List<Video> videos;

  @override
  List<Object> get props => [
        status,
        healthCheckAuth,
        currentVideo,
        videos,
      ];

  FeedState copyWith({
    Status? status,
    bool? healthCheckAuth,
    int? currentVideo,
    List<Video>? videos,
  }) {
    return FeedState._(
      status: status ?? this.status,
      healthCheckAuth: healthCheckAuth ?? this.healthCheckAuth,
      currentVideo: currentVideo ?? this.currentVideo,
      videos: videos ?? this.videos,
    );
  }
}
