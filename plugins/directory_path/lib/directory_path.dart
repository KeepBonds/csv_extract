
import 'directory_path_platform_interface.dart';

class DirectoryPath {
  Future<String?> getPlatformVersion() {
    return DirectoryPathPlatform.instance.getPlatformVersion();
  }

  Future<String?> getDirectoryPath() {
    return DirectoryPathPlatform.instance.getDirectoryPath();
  }

  Future<void> openDirectory(String path) async {
    DirectoryPathPlatform.instance.openDirectory(path);
  }
}
