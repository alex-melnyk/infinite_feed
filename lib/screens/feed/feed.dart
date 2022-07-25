import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/api/api_helper.dart';
import 'package:infinite_feed/bloc/content_bloc/content_bloc.dart';
import 'package:infinite_feed/bloc/content_bloc/content_event.dart';
import 'package:infinite_feed/bloc/content_bloc/content_state.dart';
import 'package:infinite_feed/data/repository/auth_repository.dart';
import 'package:infinite_feed/data/repository/content_repository.dart';
import 'package:swipe/swipe.dart';
import 'package:video_player/video_player.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _apiHelper = ApiHelper();
  late ContentBloc _contentBloc;

  @override
  void initState() {
    super.initState();
    _contentBloc = ContentBloc(
      AuthRepository(_apiHelper),
      ContentRepository(_apiHelper),
    );
    _contentBloc.add(InitialContentRequested());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocBuilder<ContentBloc, ContentState>(
          bloc: _contentBloc,
          builder: (context, state) {
            if (state.isInitialized) {
              return Swipe(
                  onSwipeUp: () {
                    _contentBloc.add(SwipeUp());
                  },
                  onSwipeDown: () {
                    if (state.currentIndex > 0) {
                      _contentBloc.add(SwipeDown());
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: AspectRatio(
                        aspectRatio:
                            _contentBloc.videoController!.value.aspectRatio,
                        child: VideoPlayer(
                          _contentBloc.videoController!,
                        )),
                  ));
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
