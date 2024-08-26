import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum LAPolicy {
  deviceOwnerAuthentication,
  deviceOwnerAuthenticationWithBiometrics,
  deviceOwnerAuthenticationWithBiometricsOrCompanion,
  deviceOwnerAuthenticationWithCompanion,
}

extension Localized on LAPolicy {
  String get value {
    switch (this) {
      case LAPolicy.deviceOwnerAuthenticationWithBiometrics:
        return 'deviceOwnerAuthenticationWithBiometrics';
      case LAPolicy.deviceOwnerAuthenticationWithBiometricsOrCompanion:
        return 'deviceOwnerAuthenticationWithBiometricsOrCompanion';
      case LAPolicy.deviceOwnerAuthenticationWithCompanion:
        return 'deviceOwnerAuthenticationWithCompanion';
      default:
        return 'deviceOwnerAuthentication';
    }
  }
}

class Gatekeeper {
  static const MethodChannel _channel = MethodChannel('gatekeeper');

  static Future<bool> authenticate({LAPolicy? policy, String? reason}) async {
    String? result = await _channel.invokeMethod(
      'authenticate',
      {
        'policy': policy?.value,
        'auth': reason,
      },
    );

    bool isSuccess = result == 'true';
    if (kDebugMode) print('Local Authentication Result: $result');

    return isSuccess;
  }
}
