import 'package:permission_handler/permission_handler.dart';

import 'package:yes_no_app/infrastructure/services/permissions/permissions_service.dart';

class PermissionHandlerPermissionsService extends PermissionsService{
  @override
  Future<bool> requestMicrophonePermission() async {
    // Get Permission
    final audioPermissionStatus = await Permission.microphone.status;

    // Request permission if is denied and can request it.
    if (audioPermissionStatus.isDenied) {
      final bool isAudioPermissionGranted = await Permission.microphone
          .request()
          .isGranted;

      if (!isAudioPermissionGranted) {
        return false;
      }
    }

    // Throw error if the authorization was denied permanently.
    if (audioPermissionStatus.isPermanentlyDenied) {
      return false;
    }

    // If permission was granted, return true.
    return true;
  }
}
