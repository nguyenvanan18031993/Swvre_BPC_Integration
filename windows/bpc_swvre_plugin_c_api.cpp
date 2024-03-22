#include "include/bpc_swvre/bpc_swvre_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "bpc_swvre_plugin.h"

void BpcSwvrePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  bpc_swvre::BpcSwvrePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
