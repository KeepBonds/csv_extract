import 'package:flutter_test/flutter_test.dart';
import 'package:directory_path/directory_path.dart';
import 'package:directory_path/directory_path_platform_interface.dart';
import 'package:directory_path/directory_path_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDirectoryPathPlatform
    with MockPlatformInterfaceMixin
    implements DirectoryPathPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getDirectoryPath() {
    // TODO: implement getDirectoryPath
    throw UnimplementedError();
  }

  @override
  Future<void> openDirectory(String path) {
    // TODO: implement openDirectory
    throw UnimplementedError();
  }
}

void main() {
  final DirectoryPathPlatform initialPlatform = DirectoryPathPlatform.instance;

  test('$MethodChannelDirectoryPath is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDirectoryPath>());
  });

  test('getPlatformVersion', () async {
    DirectoryPath directoryPathPlugin = DirectoryPath();
    MockDirectoryPathPlatform fakePlatform = MockDirectoryPathPlatform();
    DirectoryPathPlatform.instance = fakePlatform;

    expect(await directoryPathPlugin.getPlatformVersion(), '42');
  });
}
