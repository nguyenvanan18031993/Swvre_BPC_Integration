//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <bpc_swvre/bpc_swvre_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) bpc_swvre_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BpcSwvrePlugin");
  bpc_swvre_plugin_register_with_registrar(bpc_swvre_registrar);
}
