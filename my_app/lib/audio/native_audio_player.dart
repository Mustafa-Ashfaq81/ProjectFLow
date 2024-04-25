// ignore_for_file: avoid_print

/*
This File is regarding the native audio player of the android device
It is mainly used for our alarm functionality
*/

import 'package:flutter/services.dart';

class NativeAudioPlayer {
  static const MethodChannel _channel =
      MethodChannel('com.example.my_app/audio_player');

  static Future<void> playAudio(String filePath) async {
    try {
      await _channel.invokeMethod('playAudio', {'filePath': filePath});
    } on PlatformException catch (e) {
      print("Failed to play audio: '${e.message}'.");
    }
  }

  // New method to stop audio playback
  static Future<void> stopAudio() async {
    try {
      await _channel.invokeMethod('stopAudio');
    } on PlatformException catch (e) {
      print("Failed to stop audio: '${e.message}'.");
    }
  }

  static Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose');
    } on PlatformException catch (e) {
      print("Failed to dispose audio player: '${e.message}'.");
    }
  }
}
