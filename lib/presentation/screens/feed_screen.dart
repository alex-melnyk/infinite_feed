import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/cubits/cubits.dart';
import 'package:infinite_feed/presentation/widgets/video_page.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black87,
      extendBody: true,
      body: RefreshIndicator(
        onRefresh: context.read<FeedCubit>().refresh,
        child: BlocBuilder<FeedCubit, FeedState>(
          builder: (context, state) {
            if (state.videos.isEmpty && state.status.isRequest) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return PageView.builder(
              onPageChanged: context.read<FeedCubit>().moveTo,
              scrollDirection: Axis.vertical,
              itemCount: state.videos.length,
              itemBuilder: (context, index) {
                return VideoPage(
                  video: state.videos.elementAt(index),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
