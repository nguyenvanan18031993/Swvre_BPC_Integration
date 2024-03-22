import 'package:bpc_swvre/models/UserModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bpc_swvre_platform_interface.dart';

/// An implementation of [BpcSwvrePlatform] that uses method channels.
class MethodChannelBpcSwvre extends BpcSwvrePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bpc_swvre');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> connectSwvreSDK() async {
    final connectStatus =
        await methodChannel.invokeMethod<String>('connectSwvreSDK');
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
  Future<String?> sendEvent(String event, Map<String, dynamic>? payload) async {
    try {
      if (payload != null) {
        final result =
            await methodChannel.invokeMethod("sendEvent", <String, dynamic>{
          'payload': payload,
          'event': event,
        });
        return result;
      }
      final result =
          await methodChannel.invokeMethod("sendEvent", <String, dynamic>{
        'event': event,
      });
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to sendEvent ${e.code}');
    }
  }

  @override
  Future<String?> customeUserProperties(UserModel userModel) async {
    try {
      final result = await methodChannel
          .invokeMethod("customeUserProperties", <String, dynamic>{
        'first_name': userModel.first_name,
        'last_name': userModel.last_name,
        'balance': userModel.balance,
        'profile_status': userModel.profile_status,
        'language': userModel.language,
        'wallet_size': userModel.wallet_size,
        'phone_number': userModel.phone_number,
        'remittance_opt_in': userModel.remittance_opt_in,
      });
      print(result);
      return result;
    } on PlatformException catch (e) {
      throw ArgumentError('Unable to customeUserProperties ${e.message}');
    }
  }
}
