import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  // Request SMS and Phone Call permissions
  var status = await [
    Permission.sms,
    Permission.phone,
  ].request();

  // Check if any permissions were denied
  if (status[Permission.sms]!.isDenied || status[Permission.phone]!.isDenied) {
    // If permissions are denied, you can show an alert or a prompt to the user
    print("Permissions are required for the SOS feature to work.");
  }
}
