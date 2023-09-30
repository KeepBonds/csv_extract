#include "include/directory_path/directory_path_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "directory_path_plugin.h"

void DirectoryPathPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  directory_path::DirectoryPathPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
