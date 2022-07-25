import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/cubits/cubits.dart';
import 'package:infinite_feed/presentation/widgets/video_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();

    context.read<FeedCubit>()
      ..init()
      ..loadMore(forceLoadVideos: true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black87,
      body: BlocBuilder<FeedCubit, FeedState>(
        builder: (context, state) {
          if (state.videos.isEmpty && state.status.isRequest) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SizedBox(
            height: size.height,
            width: size.width,
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: state.videos.length,
              itemBuilder: (context, index) {
                return VideoPage(
                  video: state.videos.elementAt(index),
                  playImmediately: state.currentVideo == index,
                );
              },
              onPageChanged: (pageIndex) {
                debugPrint('Selected page: $pageIndex');

                context.read<FeedCubit>().moveTo(pageIndex);
              },
            ),
          );
        },
      ),
    );
  }
}