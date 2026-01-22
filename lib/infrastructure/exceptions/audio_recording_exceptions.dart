class AudioRecordingException implements Exception {
  final String message;

  AudioRecordingException({required this.message});

  @override
  String toString() {
    return 'There was a problem with audio recording: $message';
  }
}

class UnknownAudioRecordingException extends AudioRecordingException {
  final Exception originalException;
  UnknownAudioRecordingException({
    required this.originalException,
  }) : super(message: originalException.toString());

  @override
  String toString() {
    return 'There was a unknown problem with audio recording: $message';
  }
}
