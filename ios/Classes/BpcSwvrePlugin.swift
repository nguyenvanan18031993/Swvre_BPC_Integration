import Flutter
import UIKit
import SwrveSDK

public class BpcSwvrePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bpc_swvre", binaryMessenger: registrar.messenger())
    let instance = BpcSwvrePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "connectSwvreSDK":
    let config = SwrveConfig()
    // To use the EU stack, include this in your config.
    // config.stack = SWRVE_STACK_EU
      #if DEBUG
          SwrveSDK.sharedInstance(withAppID: 7179,
              apiKey: "general-PNdXX9jQXcSq5Oz1CMag",
              config: config)
      #else
          SwrveSDK.sharedInstance(withAppID: 7179,
              apiKey: "general-PNdXX9jQXcSq5Oz1CMag",
              config: config)
      #endif
      result("[Swvre DEBUG] Success Connect SDK")
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
    case "sendEvent":
      if let args = call.arguments as? Dictionary<String, Any> {
        guard let eventName = args["event"] as? String else {
          result(FlutterError.init(code: "event is null", message: nil, details: nil))
          return
        }
        if let payload = args["payload"] as? Dictionary<String, Any> {
          // only send event name
          SwrveSDK.event(eventName, payload: payload)
          result(payload)
        } else {
          // send event name with payload
          SwrveSDK.event(eventName)
          result(eventName)
        }
      } else {
        result(FlutterError.init(code: "bad args", message: nil, details: nil))
      }
    case "customeUserProperties":
      if let args = call.arguments as? Dictionary<String, Any> {
          SwrveSDK.userUpdate(args)
          if (SwrveSDK.started()) {
            result(SwrveSDK.userID())
          }
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
