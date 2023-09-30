#ifndef FLUTTER_PLUGIN_DIRECTORY_PATH_PLUGIN_H_
#define FLUTTER_PLUGIN_DIRECTORY_PATH_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace directory_path {

class DirectoryPathPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DirectoryPathPlugin();

  virtual ~DirectoryPathPlugin();

  // Disallow copy and assign.
  DirectoryPathPlugin(const DirectoryPathPlugin&) = delete;
  DirectoryPathPlugin& operator=(const DirectoryPathPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace directory_path

#endif  // FLUTTER_PLUGIN_DIRECTORY_PATH_PLUGIN_H_
