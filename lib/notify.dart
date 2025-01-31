import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class Notify extends GetxController {
  final isIconPlay = false.obs;
  final currentSongName = ''.obs;
  final currentSongImage = ''.obs;
  final audioPlayer = AudioPlayer();
  final currentSongUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initializeNotifications();
    setupAudioPlayer();
  }

  void setupAudioPlayer() {
    audioPlayer.setReleaseMode(ReleaseMode.stop); // Changed from loop to stop

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      isIconPlay.value = state == PlayerState.playing;
      if (state == PlayerState.playing) {
        showMusicNotification();
      }
    });
  }

  Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'music_playback',
          channelName: 'Music Playback',
          channelDescription: 'Music playback controls',
          defaultColor: const Color(0xFF1DB954), // Spotify green color
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: false,
          enableVibration: false,
          locked: true, // Makes notification persistent
        ),
      ],
      debug: true,
    );

    // Request notification permissions
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    // Set up notification action listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  // Handle notification actions
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    final notify = Get.find<Notify>();

    switch (receivedAction.buttonKeyPressed) {
      case 'PLAY':
        notify.setIconPlay(true);
        notify.showMusicNotification();
        break;
      case 'PAUSE':
        notify.setIconPlay(false);
        notify.showMusicNotification();
        break;
      case 'STOP':
        notify.setIconPlay(false);
        await AwesomeNotifications().dismiss(1);
        break;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Notification created
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Notification displayed
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Notification dismissed
  }

  void setIconPlay(bool value) {
    isIconPlay.value = value;
    if (value) {
      showMusicNotification();
    } else {
      AwesomeNotifications().dismiss(1);
    }
  }

  void updateCurrentSong(String name, String image) {
    currentSongName.value = name;
    currentSongImage.value = image;
    if (isIconPlay.value) {
      showMusicNotification();
    }
  }

  Future<void> showMusicNotification() async {
    if (currentSongName.isEmpty) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'music_playback',
        title: 'Now Playing',
        body: currentSongName.value,
        category: NotificationCategory.Transport,
        displayOnBackground: true,
        displayOnForeground: true,
        notificationLayout: NotificationLayout.MediaPlayer,
        autoDismissible: false,
      ),
      actionButtons: [
        NotificationActionButton(
          key: isIconPlay.value ? 'PAUSE' : 'PLAY',
          label: isIconPlay.value ? 'Pause' : 'Play',
          actionType: ActionType.KeepOnTop,
          enabled: true,
        ),
        NotificationActionButton(
          key: 'STOP',
          label: 'Stop',
          actionType: ActionType.KeepOnTop,
          enabled: true,
        ),
      ],
    );
  }
}
