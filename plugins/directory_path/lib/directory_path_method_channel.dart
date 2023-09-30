import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'directory_path_platform_interface.dart';

/// An implementation of [DirectoryPathPlatform] that uses method channels.
class MethodChannelDirectoryPath extends DirectoryPathPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('directory_path');

  @override
  Future<String?> getPlatformVersion() async {
    print("WESH");
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getDirectoryPath() async {
    print("WESH2");

    final version = await methodChannel.invokeMethod<String>('dir');
    return version;
  }

  @override
  Future<void> openDirectory(String path) async {
    await methodChannel.invokeMethod<String>('openDir');
  }
}
