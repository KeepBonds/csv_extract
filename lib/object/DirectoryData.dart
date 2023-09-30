import 'object.dart';

class DirectoryData {
  String directory = "";
  List<FileData> files = [];

  DirectoryData({
    required this.directory,
    required this.files,
  });

  Map<String, dynamic> toJson() {
    return {
      "directory": this.directory,
      "files": this.files.toString(),
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}