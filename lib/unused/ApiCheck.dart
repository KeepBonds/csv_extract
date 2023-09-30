import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:device_info_plus/device_info_plus.dart';

const String url = "https://www.ragic.com/acdu92/masha/2/0";

class ApiCheck {
  static Future<bool> saveInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

    Dio _dio = new Dio();
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;

    Map<String, dynamic> parameters = {};
    parameters["conversation"] = true;
    parameters["bbcode"] = true;
    parameters["api"] = true;
    parameters["fr"] = true;
    parameters["kr"] = true;
    parameters["tz"] = 8;
    parameters["approvalInfo"] = true;
    parameters["info"] = true;
    parameters["mobile"] = true;
    parameters["doFormula"] = true;
    
    _dio.options.headers['Authorization'] = "Basic eVgvaDh5N3lGN3N6cFBCdGlWeU55QWMyUkRJZDA0OS9UMXd3WUNrSCsrdkNPVDVnc2IyNlBab1hWNkZyTGxzMA==";

    DateTime currentTime = DateTime.now();
    String formattedDateTime = DateFormat("yyyy/MM/dd HH:mm:ss").format(currentTime);

    Map<String, dynamic> dataJson = {
      "_ragicId":0,
      "_star":false,
      "_parentRagicId":null,
      "_create_date":"",
      "_create_user":"edwin@ragic.com",
      "_if_entry_manager":true,
      "_locked":"","_access_user":"",
      "_notify_user":"","_index_title_":"",
      "109":"2023/08/21 09:25:24",
      "105":"2023/08/21 09:25:20",
      "108": "edwin@ragic.com",
      "_subtable_1000297":{
        "-2":{
          "_ragicId":-2,
          "_star":false,
          "_parentRagicId":"1000297",
          "_create_date":"",
          "_create_user":"edwin@ragic.com",
          "_if_entry_manager":false,
          "_locked":"",
          "_approve_status":"",
          "_approve_next":null,
          "_index_title_":"",
          "_data_nodeIds":{},
          "1000294": formattedDateTime,
          "1000295": androidInfo.model,
        }
        }
    };
    
    Response response = await _dio.post(url, queryParameters: parameters, data: dataJson);

    // get version
    RegExp regex = RegExp(r'(1000293: \d+)');
    Match? match = regex.firstMatch(response.data.toString());

    if (match != null) {
      String extractedValue = match.group(0)!;
      print(extractedValue);  // Output: 1000293: 1
      List<String> splitValue = extractedValue.split(":");
      String versionString = splitValue[1].trim();
      int? version = int.tryParse(versionString);

      if(version != null && version > 1) {
        return false;
      }
    }
    return true;
  }
}