import 'package:flutter_test/flutter_test.dart';
import 'package:bpc_swvre/bpc_swvre_platform_interface.dart';
import 'package:bpc_swvre/bpc_swvre_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockBpcSwvrePlatform
    with MockPlatformInterfaceMixin {
}

void main() {
  final BpcSwvrePlatform initialPlatform = BpcSwvrePlatform.instance;

  test('$MethodChannelBpcSwvre is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelBpcSwvre>());
  });
}
