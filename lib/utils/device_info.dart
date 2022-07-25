import 'package:uuid/uuid.dart';

/// The device info class.
class DeviceInfo {
  const DeviceInfo._();

  static const uuid = Uuid();
  static final deviceId = uuid.v4();
}
