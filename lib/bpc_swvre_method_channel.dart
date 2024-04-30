import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bpc_swvre_platform_interface.dart';

/// An implementation of [BpcSwvrePlatform] that uses method channels.
class MethodChannelBpcSwvre extends BpcSwvrePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.example.app/bpc_swvre');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> connectSwvreSDK() async {
    final connectStatus = await methodChannel.invokeMethod<String>('connectSwvreSDK');
    return connectStatus;
  }

  @override
  Future<String?> embedCampaignSwvreSDK() async {
    try {
      final result = await methodChannel.invokeMethod("embedCampaignSwvreSDK");
      print(result);
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to embedCampaignSwvreSDK ${e.message}');
    }
  }

  @override
  Future<String?> event(String event_name, Map? payload) async {
    try {
      final result =
          await methodChannel.invokeMethod("event", {'name': event_name, 'payload': payload});
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to event ${e.code}');
    }
  }

  @override
  Future<String?> userUpdate(Map? properties) async {
    try {
      final result = await methodChannel.invokeMethod("userUpdate", {'properties': properties});
      print(result);
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to userUpdate ${e.message}');
    }
  }

  @override
  Future<String?> identifySwrveUser(String external_id) async {
    try {
      final result = await methodChannel.invokeMethod("identify", {'external_id': external_id});
      print(result);
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to identifySwrveUser ${e.message}');
    }
  }
}
