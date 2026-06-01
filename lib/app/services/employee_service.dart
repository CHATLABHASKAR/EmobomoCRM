import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/employee_model.dart';
import 'dart:convert';

class EmployeeService {
  static final Dio _dio = Dio();
  static final GetStorage _box = GetStorage();

  static String? get token => _box.read('token');
  static Options get _authOptions =>
      Options(headers: {'Authorization': 'Bearer $token'});

 static Future<List<EmployeeModel>> fetchEmployees() async {
  try {
    final res = await _dio.get(
      'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/user',
      options: _authOptions,
    );
    print("Raw response: "+res.data.toString()+" (type: "+res.data.runtimeType.toString()+")");
    dynamic responseData = res.data;
    if (responseData is String) {
      try {
        responseData = jsonDecode(responseData);
        print("Decoded responseData: $responseData (type: ${responseData.runtimeType})");
      } catch (e) {
        print("❗ Could not decode responseData: $e");
        return [];
      }
    }
    if (responseData is Map && responseData.containsKey('data')) {
      var data = responseData['data'];
      print("Employee API data: $data");
      print("Type of data: "+data.runtimeType.toString());
      if (data is String) {
        print("Data is a String. Value: $data");
        if (data.trim().isEmpty) {
          print("Employee data is an empty string, treating as empty list.");
          return [];
        }
        try {
          data = jsonDecode(data);
          print("Decoded string data: $data");
          print("Decoded data type: "+data.runtimeType.toString());
        } catch (e) {
          print("❗ Failed to decode string data: $e");
          return [];
        }
      }
      if (data is List) {
        print("✅ Employees fetched: "+data.length.toString());
        for (var i = 0; i < data.length; i++) {
          print("Entry $i: "+data[i].toString()+" (type: "+data[i].runtimeType.toString()+")");
        }
        return data.map((e) {
          if (e is Map<String, dynamic>) {
            return EmployeeModel.fromJson(e);
          } else if (e is Map) {
            // If it's a Map but not Map<String, dynamic>
            return EmployeeModel.fromJson(Map<String, dynamic>.from(e));
          } else {
            print("❗ Skipping non-map employee entry: $e (type: ${e.runtimeType})");
            return null;
          }
        }).whereType<EmployeeModel>().toList();
      } else {
        print("❌ Unexpected data type after all checks: "+data.runtimeType.toString());
        return [];
      }
    } else {
      print("❌ Response is not a Map or missing 'data' key: $responseData");
      return [];
    }
  } on DioException catch (e) {
    if (e.response != null) {
      print("❗ Dio error: "+(e.response?.statusCode?.toString() ?? 'unknown'));
      print("Response: "+(e.response?.data?.toString() ?? 'no data'));
    } else {
      print("❗ Network error: "+e.message.toString());
    }
    return [];
  } catch (e) {
    print("❗ Unexpected error: $e");
    return [];
  }
}
}
