import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'package:yes_no_app/infrastructure/exceptions/exceptions.dart';

// Types
typedef OnPermissionDeniedCallback = void Function();

class VoiceMessageProvider extends ChangeNotifier {
  // Audio recorder
  final AudioRecorder _audioRecorder = AudioRecorder();

  // isRecording boolean (editing outside of this class is forbidden)
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  @override
  void dispose() {
    _audioRecorder.dispose();
    super.dispose();
  }

  /// Record audio using audiorecorder.
  /// By default, package 'record' is used.
  Future<void> startRecording({
    required OnPermissionDeniedCallback callOnPermissionDenied,
  }) async {
    try {
      // Vibrate phone
      HapticFeedback.heavyImpact();

      // Set isRecording state on UI
      _isRecording = true;
      notifyListeners();

      // Get Permission
      final audioPermissionStatus = await Permission.microphone.status;
      // Request permission if is denied and can request it.
      if (audioPermissionStatus.isDenied) {
        _isRecording = false;
        notifyListeners();

        final bool isAudioPermissionGranted = await Permission.microphone
            .request()
            .isGranted;

        if (!isAudioPermissionGranted) {
          callOnPermissionDenied();
          // throw UnauthorizedAudioRecordingException();
        }

        return;
      }

      // Throw error if the authorization was denied permanently.
      if (audioPermissionStatus.isPermanentlyDenied) {
        _isRecording = false;
        notifyListeners();

        callOnPermissionDenied();

        return;

        // throw UnauthorizedAudioRecordingException();
      }

      // Get a temporary directory to record audio
      final Directory tempDir = await getTemporaryDirectory();

      // Create a new route for file
      final String audioPath =
          '${tempDir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Configure recording
      const RecordConfig recordConfig = RecordConfig(
        encoder: AudioEncoder.aacLc, // MP4 standard
        bitRate: 128000, // Audio Quality (Recommended by Gemini)
        sampleRate: 44100, // Sampling Frequency (Recommended by Gemini)
      );

      // Start recording
      await _audioRecorder.start(recordConfig, path: audioPath);
    } on AudioRecordingException catch (_) {
      // If a known exception was received, rethow it.
      rethrow;
    } catch (exception) {
      // If there was a unknown exception, rethown as UnknownAudioRecordingException
      throw UnknownAudioRecordingException(
        originalException: Exception(exception),
      );
    }
  }

  /// Stop audio recording.
  Future<void> stopRecording() async {
    // Vibrate phone
    HapticFeedback.vibrate();

    // Indicate that recording was ended.
    _isRecording = false;
    notifyListeners();

    // Stop recording.
    try {
      final path = await _audioRecorder.stop();

      if (path != null) {
        // TODO: Enviar audio.
        print(path);
      }
    } catch (exception) {
      throw UnknownAudioRecordingException(
        originalException: Exception(exception),
      );
    }
  }
}
