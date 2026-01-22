import 'package:permission_handler/permission_handler.dart';
import 'package:yes_no_app/infrastructure/services/permissions/permissions_service.dart';

class PermissionHandlerPermissionsService extends PermissionsService {
  @override
  Future<HandledPermissionStatus> checkMicrophonePermission() async {
    final permissionStatus = await Permission.microphone.status;

    switch (permissionStatus) {
      case PermissionStatus.granted:
        return HandledPermissionStatus.granted;
      case PermissionStatus.denied:
        return HandledPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return HandledPermissionStatus.permanentlyDenied;
      default:
        return HandledPermissionStatus.notDetermined;
    }
  }

  @override
  Future<HandledPermissionStatus>
  requestMicrophonePermission() async {
    // Get Permission
    final audioPermissionRequestedStatus = await Permission.microphone
        .request();

    switch (audioPermissionRequestedStatus) {
      case PermissionStatus.granted:
        return HandledPermissionStatus.granted;
      case PermissionStatus.denied:
        return HandledPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return HandledPermissionStatus.permanentlyDenied;
      default:
        return HandledPermissionStatus.notDetermined;
    }
  }
}
