import Flutter
import LocalAuthentication
import UIKit

public class GatekeeperPlugin: NSObject, FlutterPlugin {
    var context = LAContext()
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "gatekeeper", binaryMessenger: registrar.messenger())
    let instance = GatekeeperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as! Dictionary<String, Any>
      
    switch call.method {
    case "authenticate":
        var error: NSError?
        
        let key = arguments["policy"] as? String
        let reason = arguments["reason"] as? String ?? "Authenticate to access data"
        
        var policy: LAPolicy = LAPolicy.deviceOwnerAuthentication
        
        switch key {
        case "deviceOwnerAuthenticationWithBiometrics":
            policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics
        case "deviceOwnerAuthenticationWithBiometricsOrCompanion":
            if #available(iOS 18.0, *) {
                policy = LAPolicy.deviceOwnerAuthenticationWithBiometricsOrCompanion
            }
        case "deviceOwnerAuthenticationWithCompanion":
            if #available(iOS 18.0, *) {
                policy = LAPolicy.deviceOwnerAuthenticationWithCompanion
            }
        default:
            policy = LAPolicy.deviceOwnerAuthentication
        }
        
        guard context.canEvaluatePolicy(policy, error: &error) else {
            result(error?.debugDescription)
            return
        }
        
        context.evaluatePolicy(policy, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                if (success) {
                    result("true")
                } else {
                    result(error?.localizedDescription.debugDescription)
                }
            }
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
