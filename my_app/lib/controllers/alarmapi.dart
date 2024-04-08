// ignore_for_file: sort_child_properties_last, avoid_print
// import 'dart:convert';
// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
// import 'package:alarm/src/android_alarm.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:my_app/audio/native_audio_player.dart';
// import 'package:flutter/services.dart' show rootBundle;
import '../utils/file_util.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);
  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  @override
  void initState() {
    super.initState();
  }

  final alarmSettings = AlarmSettings(
    id: 42,
    dateTime: DateTime(2024, 3, 29, 18, 56), //yy-mm-dd-HOUR-MIN
    assetAudioPath: 'audios/alarm.mp3',

    loopAudio: true,
    vibrate: true,
    volume: 0.8,
    fadeDuration: 3.0,
    notificationTitle: 'This is the title',
    notificationBody: 'This is the body',
    enableNotificationOnKill: true,
  );

  Future<void> playAlarmSound() async {
    try {
      // Copy the asset to a temporary file
      print("Copying asset to temporary file");
      final tempFile = await copyAssetToTemporaryFile('audios/alarm.mp3');
      print("Asset copied to: ${tempFile.path}");

      // Update the AlarmSettings to use the temporary file path
      final updatedAlarmSettings = alarmSettings.copyWith(
        assetAudioPath: tempFile.path,
      );

      // Use the NativeAudioPlayer to play the audio from the temporary file
      await NativeAudioPlayer.playAudio(tempFile.path);

      // Set the alarm with the updated AlarmSettings
      await Alarm.set(alarmSettings: updatedAlarmSettings);
    } catch (e) {
      print("Error playing alarm sound: $e");
    }
  }

  @override
  void dispose() {
    NativeAudioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter alarm clock example 2'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(25),
                child: TextButton(
                  child: const Text(
                    'Create alarm at 23:59',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: playAlarmSound, // Updated to use the new method
                ),
              ),
              Container(
                margin: const EdgeInsets.all(25),
                child: TextButton(
                  child: const Text(
                    'Stop Alarm',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    NativeAudioPlayer.stopAudio(); // Call the stop method
                    Alarm.stop(alarmSettings.id); // Cancel the scheduled alarm
                  },
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.all(25),
              //   child: const TextButton(
              //     onPressed: FlutterAlarmClock.showAlarms,
              //     child: Text(
              //       'Show alarms',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.all(25),
              //   child: TextButton(
              //     child: const Text(
              //       'Create timer for 42 seconds',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //     onPressed: () {
              //       FlutterAlarmClock.createTimer(length: 42);
              //     },
              //   ),
              // ),
              // Container(
              //   margin: const EdgeInsets.all(25),
              //   child: const TextButton(
              //     onPressed: FlutterAlarmClock.showTimers,
              //     child: Text(
              //       'Show Timers',
              //       style: TextStyle(fontSize: 20),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
