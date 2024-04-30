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

  Future<String?> event(String event, Map? payload) {
    return BpcSwvrePlatform.instance.event(event, payload);
  }

  Future<String?> userUpdate(Map properties) {
    return BpcSwvrePlatform.instance.userUpdate(properties);
  }

  Future<String?> identifySwrveUser(String external_id) {
    return BpcSwvrePlatform.instance.identifySwrveUser(external_id);
  }
}
