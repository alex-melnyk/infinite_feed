import 'package:uuid/uuid.dart';

class DeviceInfo {
  static String? deviceId;

  initId() {
    const uuid = Uuid();
    deviceId = uuid.v4();
  }
}
