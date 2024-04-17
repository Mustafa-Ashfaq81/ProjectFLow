// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:my_app/audio/native_audio_player.dart';
import '../utils/file_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



// Define a StatefulWidget for the Alarm Page
class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

// Define the state for the Alarm Page
class _AlarmPageState extends State<AlarmPage> {
  DateTime? _selectedAlarmTime;
  AlarmSettings? alarmSettings;
  bool _isAlarmRinging = false;

    // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 // Perform initialization tasks when the state is initialized
  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  // Initialize local notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  // Handle notification response
  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload == 'stop_alarm') {
      await NativeAudioPlayer.stopAudio();
      await Alarm.stop(alarmSettings!.id);
      await flutterLocalNotificationsPlugin
          .cancel(notificationResponse.id!); // Cancel the notification
    }
  }




  // Play the alarm sound and schedule the alarm
  Future<void> playAlarmSound() async {
    if (_selectedAlarmTime == null) {
      print("No alarm time selected");
      return;
    }

    // Define alarm settings
    alarmSettings = AlarmSettings(
      id: 42,
      dateTime: _selectedAlarmTime!,
      assetAudioPath: 'audios/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'Alarm Title',
      notificationBody: 'Alarm Body',
      enableNotificationOnKill: true,
    );

    try {
      // Copy the asset to a temporary file
      debugPrint("Copying asset to temporary file");
      final tempFile = await copyAssetToTemporaryFile('audios/alarm.mp3');
      debugPrint("Asset copied to: ${tempFile.path}");

      // Update the AlarmSettings to use the temporary file path
      final updatedAlarmSettings = alarmSettings!.copyWith(
        assetAudioPath: tempFile.path,
      );

      // Set the alarm with the updated AlarmSettings
      await Alarm.set(alarmSettings: updatedAlarmSettings);
      debugPrint("Alarm set successfully");

      setState(() {
        _isAlarmRinging = true;
      });

      // Create a notification channel
      const channelId = 'alarm_channel';
      const channelName = 'Alarm Channel';
      const channelDescription = 'Channel for alarm notifications';

      final notificationChannel = AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(notificationChannel);
      debugPrint("Notification channel created");

      // Create a notification with a "Stop Alarm" action button
      const notificationId = 42; // Use a unique notification ID
      const notificationTitle = 'Alarm';
      const notificationBody = 'Tap to stop the alarm';

      final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        fullScreenIntent: true,
        icon: 'ic_stop',
        actions: [
          AndroidNotificationAction(
            'stop_alarm',
            'Stop Alarm',
            icon: DrawableResourceAndroidBitmap('@drawable/ic_stop'),
          ),
        ],
      );

      final platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        notificationId,
        notificationTitle,
        notificationBody,
        platformChannelSpecifics,
        payload: 'stop_alarm',
      );
      debugPrint("Notification shown");
    } catch (e) {
      debugPrint("Error setting alarm: $e");
    }
  }


    // Select the alarm time
  Future<void> _selectAlarmTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _selectedAlarmTime = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          selectedTime.hour,
          selectedTime.minute,
        );
      });
    }
  }


  // stop alarm function
  Future<void> stopAlarm() async {
    if (alarmSettings != null) {
      await NativeAudioPlayer.stopAudio(); // Stop the sound
      await Alarm.stop(alarmSettings!.id); // Cancel the scheduled alarm
      await flutterLocalNotificationsPlugin
          .cancel(alarmSettings!.id); // Optionally cancel the notification

      setState(() {
        _isAlarmRinging = false;
      });
    }
  }

  @override


  
  // Build the UI for the Alarm Page
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Alarm Clock Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => _selectAlarmTime(context),
                child:
                    Text('Select Alarm Time', style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: playAlarmSound,
                child: Text('Set Alarm', style: TextStyle(fontSize: 20)),
              ),
              // Conditionally display the stop button based on the alarm state
              if (_isAlarmRinging)
                TextButton(
                  onPressed: stopAlarm,
                  child: Text('Stop Alarm', style: TextStyle(fontSize: 20)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
