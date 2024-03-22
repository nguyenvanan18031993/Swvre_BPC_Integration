import 'package:bpc_swvre/models/UserModel.dart';

import 'bpc_swvre_platform_interface.dart';

class BpcSwvre {
  Future<String?> getPlatformVersion() {
    return BpcSwvrePlatform.instance.getPlatformVersion();
  }

  Future<String?> connectSwvreSDK() {
    return BpcSwvrePlatform.instance.connectSwvreSDK();
  }

  Future<String?> embedCampaignSwvreSDK() {
    return BpcSwvrePlatform.instance.embedCampaignSwvreSDK();
  }

  Future<String?> sendEvent(String event, Map<String, dynamic>? payload) {
    return BpcSwvrePlatform.instance.sendEvent(event, payload);
  }

  Future<String?> customeUserProperties(UserModel userModel) {
    return BpcSwvrePlatform.instance.customeUserProperties(userModel);
  }
}
