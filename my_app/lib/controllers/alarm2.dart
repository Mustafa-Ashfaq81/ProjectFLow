import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
// import 'package:alarm/src/android_alarm.dart';

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
    dateTime: DateTime(2024,3,30,1,45), //yy-mm-dd-HOUR-MIN
    assetAudioPath: 'audios/alarm.mp3',
    loopAudio: true,
    vibrate: true,
    volume: 0.8,
    fadeDuration: 3.0,
    notificationTitle: 'This is the title',
    notificationBody: 'This is the body',
    enableNotificationOnKill: true,
  );

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
                  onPressed: () async {
                    await Alarm.set(alarmSettings: alarmSettings);
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


