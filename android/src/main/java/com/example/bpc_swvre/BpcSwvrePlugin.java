package com.example.bpc_swvre;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Build;

import androidx.annotation.NonNull;

import com.swrve.sdk.SwrveIdentityResponse;
import com.swrve.sdk.SwrveSDK;
import com.swrve.sdk.config.SwrveConfig;
import com.swrve.sdk.config.SwrveStack;
import com.swrve.sdk.messaging.SwrveEmbeddedListener;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;

/** BpcSwvrePlugin */
public class BpcSwvrePlugin extends Application implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native
  /// Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine
  /// and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private Activity activity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.example.app/bpc_swrve");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "event":
        swrveEvent(call);
        break;
      case "userUpdate":
        swrveUserUpdate(call);
        break;
      case "identify":
        swrveIdentify(call);
        break;
      case "setSwrveProperties":
        SwrveSDK.userUpdate(call.argument("properties"));
        break;
      default:
        result.notImplemented();
    }
    // switch (call.method) {
    // case "getPlatformVersion":
    // result.success("Android " + Build.VERSION.RELEASE);
    // break;
    // case "connectSwvreSDK":
    // try {
    // SwrveConfig config = new SwrveConfig();
    // // To use the EU stack, include this in your config.
    // config.setSelectedStack(SwrveStack.EU);
    // SwrveSDK.createInstance(activity.getApplication(), 7179,
    // "general-PNdXX9jQXcSq5Oz1CMag", config);
    // result.success("Connect successfully");
    // } catch (IllegalArgumentException exp) {
    // result.success("Could not initialize the Swrve SDK " + exp);
    // }
    // break;
    // case "embedCampaignSwvreSDK":
    // SwrveEmbeddedListener embeddedListener = (context, message,
    // personalizationProperties, isControl) -> {
    // if (isControl) {
    // // this campaign should not be shown to user, to help with reporting you
    // should
    // // use the api below to send us an impression event
    // SwrveSDK.embeddedControlMessageImpressionEvent(message);
    // result.success("[Swvre DEBUG] embeddedControlMessageImpressionEvent");
    // } else {
    // // returns the message data with personalization resolved. It will be null if
    // it
    // // could not resolve.
    // String resolvedMessageData =
    // SwrveSDK.getPersonalizedEmbeddedMessageData(message,
    // personalizationProperties);
    // // continue with normal logic

    // // If you want to track an impression event
    // SwrveSDK.embeddedMessageWasShownToUser(message);
    // result.success("[Swvre DEBUG] embeddedMessageWasShown");

    // // The message object returns a list of strings representing the button
    // options.
    // // In this example we are taking out the first button from the list and
    // sending
    // // a click event
    // if (message.getButtons() != null) {
    // if (message.getButtons().size() == 1) {
    // String buttonName = message.getButtons().get(0);
    // SwrveSDK.embeddedMessageButtonWasPressed(message, buttonName);
    // result.success("[Swvre DEBUG] embeddedButtonWasPressed");
    // }
    // }
    // result.success("[Swvre DEBUG] complete");
    // }

    // };
    // break;
    // case "event":
    // result.success(call.argument("payload"));
    // try {
    // SwrveSDK.event(call.argument("name"), call.argument("payload"));
    // } catch (IllegalArgumentException exp) {
    // result.success(exp);
    // }
    // break;
    // case "setSwrveProperties":
    // SwrveSDK.userUpdate(call.argument("properties"));
    // break;
    // case "identify":
    // SwrveSDK.identify(call.argument("external_id"), new SwrveIdentityResponse() {
    // @Override
    // public void onSuccess(String status, String swrveId) {
    // result.success(swrveId);
    // }

    // @Override
    // public void onError(int responseCode, String errorMessage) {
    // result.success(errorMessage);
    // }
    // });
    // break;
    // default:
    // result.notImplemented();
    // }
  }

  private void swrveEvent(MethodCall call) {
    SwrveSDK.event(call.argument("name"), call.argument("payload"));
  }

  private void swrveUserUpdate(MethodCall call) {
    SwrveSDK.userUpdate(call.argument("properties"));
  }

  private void swrveIdentify(MethodCall call) {
    SwrveSDK.identify(call.argument("external_id"), new SwrveIdentityResponse() {
      @Override
      public void onSuccess(String status, String swrveId) {
        // Success, continue with your logic
      }

      @Override
      public void onError(int responseCode, String errorMessage) {
        // Error should be handled.
      }
    });
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }
}
