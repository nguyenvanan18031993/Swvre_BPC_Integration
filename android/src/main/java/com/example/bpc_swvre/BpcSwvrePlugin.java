package com.example.bpc_swvre;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.swrve.sdk.SwrveSDK;
import com.swrve.sdk.config.SwrveConfig;
import com.swrve.sdk.config.SwrveEmbeddedMessageConfig;
import com.swrve.sdk.config.SwrveStack;
import com.swrve.sdk.messaging.SwrveEmbeddedListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
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
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bpc_swvre");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("Android " + Build.VERSION.RELEASE);
        break;
      case "connectSwvreSDK":
        try {
          SwrveConfig config = new SwrveConfig();
          // To use the EU stack, include this in your config.
          config.setSelectedStack(SwrveStack.EU);
          SwrveSDK.createInstance(activity.getApplication(), 7179, "general-PNdXX9jQXcSq5Oz1CMag", config);
          result.success("Connect successfully");
        } catch (IllegalArgumentException exp) {
          result.success("Could not initialize the Swrve SDK " + exp);
        }
        break;
      case "embedCampaignSwvreSDK":
        SwrveEmbeddedListener embeddedListener = (context, message, personalizationProperties, isControl) -> {
          if (isControl) {
            // this campaign should not be shown to user, to help with reporting you should
            // use the api below to send us an impression event
            SwrveSDK.embeddedControlMessageImpressionEvent(message);
            result.success("[Swvre DEBUG] embeddedControlMessageImpressionEvent");
          } else {
            // returns the message data with personalization resolved. It will be null if it
            // could not resolve.
            String resolvedMessageData = SwrveSDK.getPersonalizedEmbeddedMessageData(message,
                personalizationProperties);
            // continue with normal logic

            // If you want to track an impression event
            SwrveSDK.embeddedMessageWasShownToUser(message);
            result.success("[Swvre DEBUG] embeddedMessageWasShown");

            // The message object returns a list of strings representing the button options.
            // In this example we are taking out the first button from the list and sending
            // a click event
            if (message.getButtons() != null) {
              if (message.getButtons().size() == 1) {
                String buttonName = message.getButtons().get(0);
                SwrveSDK.embeddedMessageButtonWasPressed(message, buttonName);
                result.success("[Swvre DEBUG] embeddedButtonWasPressed");
              }
            }
            result.success("[Swvre DEBUG] complete");
          }

        };
        break;
      case "sendEvent":
        final String eventName = call.argument("event");
        final Map<String, String> payload = call.argument("payload");
        if (eventName != null) {
          // only send event name
          if (payload != null) {
            SwrveSDK.event(eventName, payload);
            result.success("Event with payload");
          } else {
            SwrveSDK.event(eventName);
            result.success(eventName);
          }
        } else {
          result.success("bad args");
        }
        break;
      case "customeUserProperties":
        final Map<String, String> args = call.arguments();
        if (args != null) {
          SwrveSDK.userUpdate(args);
          if (SwrveSDK.isStarted()) {
            result.success(SwrveSDK.getUserId());
          }
        } else {
          result.success("bad args");
        }
        break;
      default:
        result.notImplemented();
    }
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
