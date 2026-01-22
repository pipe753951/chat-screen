import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import 'package:yes_no_app/infrastructure/services/recording/audio_recording_service.dart';

class RecordAudioRecordingService extends AudioRecordingService {
  // Audio recorder
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void dispose() {
    _audioRecorder.dispose();
  }

  @override
  Future<void> startRecording() async {
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
  }

  @override
  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    return path;
  }
}
