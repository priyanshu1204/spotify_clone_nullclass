import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'Screen/home_page.dart';
import 'Screen/library.dart';
import 'Screen/premium.dart';
import 'Screen/search.dart';
import 'data.dart';
import 'notify.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // AwesomeNotifications().initialize(
  //   null, // Default icon
  [
    //     NotificationChannel(
    //       channelKey: 'spotify',
    //       channelName: 'Spotify Notifications',
    //       channelDescription: 'Notifications for playing/pausing music',
    //       importance: NotificationImportance.High,
    //       enableVibration: false,
    //       channelShowBadge: true,
    //     ),
    //   ],
    // );
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic',
          channelName: 'Basic Notifications',
          channelDescription: 'Basic notifications for audio player actions',
          importance: NotificationImportance.High,
          enableVibration: true,
          playSound: true,
        ),
        NotificationChannel(
          channelKey: 'spotify',
          channelName: 'Spotify Notifications',
          channelDescription: 'Notifications for playing/pausing music',
          importance: NotificationImportance.High,
          enableVibration: false,
          channelShowBadge: true,
        ),
      ],
    ),
  ];

  AwesomeNotifications().setListeners(
    onActionReceivedMethod: (receivedAction) async {
      // Handle notification actions globally
    },
  );
  Get.put(Data());
  Get.put(Notify());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Notify notify = Get.put(Notify());

  MyApp({super.key}); // Initialize GetX controller

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/search': (context) => const Search(),
        '/library': (context) => const Library(),
        '/premium': (context) => const Premium(),
      },
    );
  }
}
