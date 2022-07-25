import 'package:flutter/material.dart';
import 'package:infinite_feed/screens/feed/feed.dart';
import 'package:infinite_feed/utils/device_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfo().initId();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FeedPage(),
    );
  }
}
