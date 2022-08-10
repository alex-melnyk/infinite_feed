import 'package:flutter/material.dart';

class VideoProgress extends StatelessWidget {
  const VideoProgress({
    Key? key,
    this.value = 0.0,
    this.decoration = _containerDecoration,
    this.progressDecoration = _progressDecoration,
  }) : super(key: key);

  static const _containerDecoration = BoxDecoration(
    color: Colors.white30,
  );
  static const _progressDecoration = BoxDecoration(
    color: Colors.white,
  );

  final double value;
  final BoxDecoration decoration;
  final BoxDecoration progressDecoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 5,
      decoration: _containerDecoration,
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: value,
        heightFactor: 1.0,
        child: const DecoratedBox(
          decoration: _progressDecoration,
        ),
      ),
    );
  }
}
