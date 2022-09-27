import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
 // final Permission permissionHandler = Permission();

  /*Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }    return false;
  }

  Future<bool> requestStoragePermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.storage);
    if (!granted) {
      onPermissionDenied();
    }
    return granted;
  }*/


  Future<bool> _requestPermission() async {

    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.contacts,
      Permission.storage,
      //add more permission to request here.
    ].request();

    if(statuses[Permission.phone]!.isGranted){ //check each permission status after.
      print("Location permission is denied.");
      return true;
    }
    if(statuses[Permission.contacts]!.isGranted){ //check each permission status after.
      print("Location permission is denied.");
      return true;
    }
    if(statuses[Permission.storage]!.isGranted){ //check each permission status after.
      print("Location permission is denied.");
      return true;
    }
    /*var result = await  permissionHandler.requestPermissions([
      Permission.phone,
      PermissionGroup.contacts,
      PermissionGroup.sms,
      PermissionGroup.storage]);
    if (result == PermissionStatus.granted) {
      return true;
    }*/
    return false;
  }

  Future<bool> requestStoragePermission({Function? onPermissionDenied}) async {
    var granted = await _requestPermission();
    if (!granted) {
      onPermissionDenied!();
    }
    return granted;
  }


}