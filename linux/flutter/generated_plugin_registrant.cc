//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <directory_path/directory_path_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) directory_path_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DirectoryPathPlugin");
  directory_path_plugin_register_with_registrar(directory_path_registrar);
}
