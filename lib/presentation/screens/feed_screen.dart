import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/cubits/cubits.dart';
import 'package:infinite_feed/presentation/widgets/video_page.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _pageController = PageController();

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
            child: RefreshIndicator(
              onRefresh: () async {
                await context.read<FeedCubit>().refresh();

                // REFRESH THE PageView TRICK
                _pageController.jumpToPage(1);
                await Future.delayed(const Duration(milliseconds: 100));
                _pageController.jumpToPage(0);
              },
              child: PageView.builder(
                onPageChanged: context.read<FeedCubit>().moveTo,
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.videos.length,
                itemBuilder: (context, index) {
                  return VideoPage(
                    video: state.videos.elementAt(index),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }
}
