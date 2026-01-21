import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yes_no_app/domain/domain.dart';

import 'package:yes_no_app/infrastructure/exceptions/exceptions.dart';
import 'package:yes_no_app/infrastructure/services/services.dart';

// Types
typedef OnPermissionDeniedCallback = void Function();
typedef OnSendVoiceMessage = void Function(VoiceMessage message);

class VoiceMessageProvider extends ChangeNotifier {
  VoiceMessageProvider(this.onSendVoiceMessage);

  // Required functions
  final OnSendVoiceMessage onSendVoiceMessage;

  // isRecording boolean (editing outside of this class is forbidden)
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// Timer
  Timer? _timer;

  /// Record duration (in seconds)
  int _recordDuration = 0;

  /// Voice Recording button drag offset
  double _dragOffset = 0.0;
  double get dragOffset => _dragOffset;

  /// Position where the recording cancels.
  final double _cancelThreshold = -200.0;

  String get recordDurationFormatted {
    final String minutes = (_recordDuration ~/ 60).toString().padLeft(2, '0');
    final String seconds = (_recordDuration % 60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

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

      // TODO: Cancel Recording if permission was granted but previously not determined.

      // Start recording
      audioRecordingService.startRecording();

      // Start timer
      _startTimer();
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
  Future<void> stopRecording({bool cancel = false}) async {
    // Vibrate phone
    HapticFeedback.vibrate();

    // Indicate that recording was ended and stop timer.
    _isRecording = false;
    _dragOffset = 0;
    _stopTimer();

    notifyListeners();

    // Stop recording.
    try {
      final path = await audioRecordingService.stopRecording();

      if (cancel || path == null) return;

      _returnRecordedMessage(path);
    } catch (exception) {
      throw UnknownAudioRecordingException(
        originalException: Exception(exception),
      );
    }
  }

  /// Send a new [VoiceMessage] to proccess as widget MessageField has indicated.
  void _returnRecordedMessage(String path) {
    // Create voice message
    final VoiceMessage recordedVoiceMessage = VoiceMessage(
      fromWho: FromWho.me,
      location: path,
    );

    onSendVoiceMessage(recordedVoiceMessage);
  }

  /// Update drag offset
  void updateDragOffset(double offset) {
    if (!isRecording) return;

    if (offset < 0) _dragOffset = offset;
    notifyListeners();

    if (_dragOffset <= _cancelThreshold) {
      stopRecording(cancel: true);
      notifyListeners();
    }
  }

  /// Start audio recording timer
  void _startTimer() {
    _recordDuration = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _recordDuration++;
      notifyListeners();
    });
  }

  /// Stop audio recording timer
  void _stopTimer() {
    _timer?.cancel();
    _recordDuration = 0;
  }
}
