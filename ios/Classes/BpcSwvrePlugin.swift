import Flutter
import UIKit
import SwrveSDK
import SwrveSDKCommon

public class BpcSwvrePlugin: NSObject, FlutterPlugin {

    let NotificationCategoryIdentifier = "com.swrve.sampleAppButtons"
    let NotificationActionOneIdentifier = "ACTION1"
    let NotificationActionTwoIdentifier = "ACTION2"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.example.app/bpc_swvre", binaryMessenger: registrar.messenger())
    let instance = BpcSwvrePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
      case "connectSwvreSDK":
      let config = SwrveConfig()
        // To use the EU stack, include this in your config.
        config.stack = SWRVE_STACK_EU
        // Set the response delegate before Swrve is initialized
        config.pushResponseDelegate = self
        config.pushEnabled = true
        config.pushNotificationPermissionEvents = Set(["tutorial.complete", "subscribe"])
        if let args = call.arguments as? Dictionary<String, Any> {
          guard let swrveAPPID = args["swrveAPPID"] as? Int else {
              result(FlutterError.init(code: "swrveAPPID is null", message: nil, details: nil))
              return
          }
          guard let swrveAPIKey = args["swrveAPIKey"] as? String else {
              result(FlutterError.init(code: "swrveAPIKey is null", message: nil, details: nil))
              return
          }
          SwrveSDK.sharedInstance(withAppID: Int32(swrveAPPID),
                                    apiKey: swrveAPIKey,
                                    config: config)   
          result("[Swvre DEBUG] connectSwvreSDK complete")
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
        break
      case "embedCampaignSwvreSDK":
        let embeddedConfig = SwrveEmbeddedMessageConfig()
        embeddedConfig.embeddedCallback = { message, personalizationProperties, isControl in
            if isControl {
                // this campaign should not be shown to user, to help with reporting you should use the api below to send us an impression event
                SwrveSDK.embeddedControlMessageImpressionEvent(message!)
                result("[Swvre DEBUG] embeddedControlMessageImpressionEvent")
            } else {
                
                let messageData = SwrveSDK.personalizeEmbeddedMessageData(message!, withPersonalization: personalizationProperties!)
                // continue with normal logic
                
                // If you want to track an impression event
                SwrveSDK.embeddedMessageWasShown(toUser: message!)
                result("[Swvre DEBUG] embeddedMessageWasShown")
            }
            
            if let buttons = message?.buttons {
                if buttons.count == 1 {
                    if let buttonName = buttons[0] as? NSString {
                        SwrveSDK.embeddedButtonWasPressed(message!, buttonName: buttonName as String)
                        result("[Swvre DEBUG] embeddedButtonWasPressed")
                    }
                }
            }

            result("[Swvre DEBUG] complete")
        }
    case "event":
      if let args = call.arguments as? Dictionary<String, Any> {
          guard let event_name = args["name"] as? String else {
              result(FlutterError.init(code: "event name is null", message: nil, details: nil))
              return
          }
          if let payload = args["payload"] as? Dictionary<String, Any> {
              // only send event name
              // send event name with payload
              DispatchQueue.main.async {
                  SwrveSDK.event(event_name, payload: payload)
                  result(event_name)
              }
          } else {
              // send event name with payload
              DispatchQueue.main.async {
                  SwrveSDK.event(event_name)
                  result(event_name)
              }
          }
        
      } else {
        result(FlutterError.init(code: "bad args", message: nil, details: nil))
      }
    case "userUpdate":
      if let properties = call.arguments as? Dictionary<String, Any> {
          SwrveSDK.userUpdate(properties)
          if (SwrveSDK.started()) {
            result(SwrveSDK.userID())
          }
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
      case "identify":
        if let args = call.arguments as? Dictionary<String, Any> {
            guard let external_id = args["external_id"] as? String else {
              result(FlutterError.init(code: "external_id is null", message: nil, details: nil))
              return
            }
            SwrveSDK.identify(external_id, onSuccess: { (status, swrveUserId) in
                // Success, continue with your logic
            }) { (httpCode, errorMessage) in
                // Error should be handled
            }
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

//MARK: SwrvePushResponseDelegate implementation

extension BpcSwvrePlugin:  SwrvePushResponseDelegate {
    @available(iOS 10.0, *)
    public func didReceive(_ response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        print("Got iOS 10 Notification with Identifier - \(response.actionIdentifier)")
        // Include your own code in here
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    public func willPresent(_ notification: UNNotification, withCompletionHandler completionHandler: ((UNNotificationPresentationOptions) -> Void)) {
        // Include your own code in here
        completionHandler([])
    }
}