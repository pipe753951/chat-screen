enum HandledPermissionStatus {notDetermined, granted, denied, permanentlyDenied}

abstract class PermissionsService {
  Future<HandledPermissionStatus> checkMicrophonePermission();
  Future<HandledPermissionStatus> requestMicrophonePermission();
}
