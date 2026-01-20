import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:yes_no_app/infrastructure/exceptions/exceptions.dart';
import 'package:yes_no_app/infrastructure/services/services.dart';

// Types
typedef OnPermissionDeniedCallback = void Function();

class VoiceMessageProvider extends ChangeNotifier {
  // isRecording boolean (editing outside of this class is forbidden)
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  final AudioRecordingService audioRecordingService =
      RecordAudioRecordingService();
  final PermissionsService permissionsService =
      PermissionHandlerPermissionsService();

  @override
  void dispose() {
    audioRecordingService.dispose();
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

      // Request permission
      await permissionsService.requestMicrophonePermission();

      audioRecordingService.startRecording();
    }
    // If the microphone permision was denied, inform it to user.
    on UnauthorizedAudioRecordingException catch (_) {
      _isRecording = false;
      notifyListeners();

      callOnPermissionDenied();
    }
    // If there was a unknown exception, rethown as UnknownAudioRecordingException
    catch (exception) {
      // TODO: Control other exceptions.
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
      final path = await audioRecordingService.stopRecording();

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
