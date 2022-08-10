extension DurationExtension on Duration {
  /// Returns deference between this and [other], otherwise returns 0.0.
  double operator /(Duration other) {
    final result = inMilliseconds / other.inMilliseconds;

    if (result.isNaN) {
      return 0.0;
    }

    return result;
  }
}
