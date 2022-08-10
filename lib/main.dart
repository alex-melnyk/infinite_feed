import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_feed/cubits/cubits.dart';
import 'package:infinite_feed/presentation/presentation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => FeedCubit()..init(),
            lazy: false,
          ),
        ],
        child: const FeedScreen(),
      ),
    );
  }
}
