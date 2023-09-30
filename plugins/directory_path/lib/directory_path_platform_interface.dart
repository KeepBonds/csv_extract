import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'directory_path_method_channel.dart';

abstract class DirectoryPathPlatform extends PlatformInterface {
  /// Constructs a DirectoryPathPlatform.
  DirectoryPathPlatform() : super(token: _token);

  static final Object _token = Object();

  static DirectoryPathPlatform _instance = MethodChannelDirectoryPath();

  /// The default instance of [DirectoryPathPlatform] to use.
  ///
  /// Defaults to [MethodChannelDirectoryPath].
  static DirectoryPathPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DirectoryPathPlatform] when
  /// they register themselves.
  static set instance(DirectoryPathPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getDirectoryPath() async =>
      throw UnimplementedError('getDirectoryPath() has not been implemented.');

  Future<void> openDirectory(String path) async =>
      throw UnimplementedError('getDirectoryPath() has not been implemented.');
}
