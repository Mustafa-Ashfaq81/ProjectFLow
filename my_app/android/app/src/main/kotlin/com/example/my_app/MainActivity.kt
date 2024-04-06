package com.example.my_app // Use your package name

import android.media.MediaPlayer
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.my_app/audio_player"
    private var mediaPlayer: MediaPlayer? = null // Declare MediaPlayer at class level

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "playAudio" -> {
                    mediaPlayer?.reset() // Reset before using
                    val filePath = call.argument<String>("filePath")
                    Log.d("AudioService", "Requested to play audio from path: $filePath")

                    // Check file existence
                    val file = File(filePath)
                    if (!file.exists()) {
                        Log.e("AudioService", "File not found at path: $filePath")
                        result.error("FILE_NOT_FOUND", "File not found at path: $filePath", null)
                        return@setMethodCallHandler
                    }

                    // Try to play audio
                    try {
                        mediaPlayer = MediaPlayer().apply {
                            setDataSource(filePath)
                            prepare()
                            start()
                        }
                        Log.d("AudioService", "Audio playback started successfully.")
                        result.success(null)
                    } catch (e: Exception) {
                        Log.e("AudioService", "Error playing audio", e)
                        result.error("UNAVAILABLE", "Audio playback failed: ${e.message}", null)
                    }
                }
                "stopAudio" -> {
                    mediaPlayer?.stop() // Stop audio
                    // mediaPlayer?.reset() // Reset player
                    Log.d("AudioService", "Audio playback stopped.")
                    result.success(null)
                }
                
                "dispose" -> {
                    mediaPlayer?.release() // Release resources
                    mediaPlayer = null
                    Log.d("AudioService", "MediaPlayer disposed.")
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
