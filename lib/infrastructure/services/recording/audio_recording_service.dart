abstract class AudioRecordingService {
  Future<void> startRecording();
  Future<String?> stopRecording();
  void dispose();
}
