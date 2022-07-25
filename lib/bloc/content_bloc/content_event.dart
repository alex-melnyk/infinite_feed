import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object> get props => [];
}

class InitialContentRequested extends ContentEvent {}

class InitialContentLoaded extends ContentEvent {}

class ContentRequested extends ContentEvent {}

class ContentInitialized extends ContentEvent {}

class SwipeUp extends ContentEvent {}

class SwipeDown extends ContentEvent {}
