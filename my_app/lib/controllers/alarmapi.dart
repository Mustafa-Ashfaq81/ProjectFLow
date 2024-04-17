// ignore_for_file: prefer_const_constructors, prefer_final_fields, avoid_print, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:my_app/audio/native_audio_player.dart';
import '../utils/file_util.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  DateTime? _selectedAlarmTime;
  AlarmSettings? alarmSettings;
  bool _isAlarmRinging = false;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

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

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (payload == 'stop_alarm') {
      await NativeAudioPlayer.stopAudio();
      await Alarm.stop(alarmSettings!.id);
      await flutterLocalNotificationsPlugin.cancel(notificationResponse.id!);
    }
  }

  Future<void> playAlarmSound() async {
    if (_selectedAlarmTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an alarm time')),
      );
      return;
    }

    alarmSettings = AlarmSettings(
      id: 42,
      dateTime: _selectedAlarmTime!,
      assetAudioPath: 'audios/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'Alarm',
      notificationBody: 'Wake up!',
      enableNotificationOnKill: true,
    );

    try {
      final tempFile = await copyAssetToTemporaryFile('audios/alarm.mp3');
      final updatedAlarmSettings = alarmSettings!.copyWith(
        assetAudioPath: tempFile.path,
      );

      await Alarm.set(alarmSettings: updatedAlarmSettings);

      setState(() {
        _isAlarmRinging = true;
      });

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

      const notificationId = 42;
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error setting alarm: $e')),
      );
    }
  }

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

  Future<void> stopAlarm() async {
    if (alarmSettings != null) {
      await NativeAudioPlayer.stopAudio();
      await Alarm.stop(alarmSettings!.id);
      await flutterLocalNotificationsPlugin.cancel(alarmSettings!.id);

      setState(() {
        _isAlarmRinging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Alarm Clock'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Select Alarm Time',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () => _selectAlarmTime(context),
                  child: Text(
                    _selectedAlarmTime != null
                        ? '${_selectedAlarmTime!.hour.toString().padLeft(2, '0')}:${_selectedAlarmTime!.minute.toString().padLeft(2, '0')}'
                        : 'Select Time',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: playAlarmSound,
                  child: Text('Set Alarm', style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_isAlarmRinging)
                Center(
                  child: ElevatedButton(
                    onPressed: stopAlarm,
                    child: Text('Stop Alarm', style: TextStyle(fontSize: 20)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
