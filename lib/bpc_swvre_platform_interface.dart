import 'dart:ffi';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bpc_swvre_method_channel.dart';

abstract class BpcSwvrePlatform extends PlatformInterface {
  /// Constructs a BpcSwvrePlatform.
  BpcSwvrePlatform() : super(token: _token);

  static final Object _token = Object();

  static BpcSwvrePlatform _instance = MethodChannelBpcSwvre();

  /// The default instance of [BpcSwvrePlatform] to use.
  ///
  /// Defaults to [MethodChannelBpcSwvre].
  static BpcSwvrePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BpcSwvrePlatform] when
  /// they register themselves.
  static set instance(BpcSwvrePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> connectSwvreSDK(int swrveAPPID,String swrveAPIKey) {
    throw UnsupportedError('connectSwvreSDK() has not been implemented.');
  }

  Future<String?> embedCampaignSwvreSDK() {
    throw UnimplementedError();
  }

  Future<String?> event(String event_name, Map? payload) {
    throw UnimplementedError();
  }

  Future<String?> userUpdate(Map properties) {
    throw UnimplementedError();
  }

  Future<String?> identifySwrveUser(String external_id) {
    throw UnimplementedError();
  }
}
