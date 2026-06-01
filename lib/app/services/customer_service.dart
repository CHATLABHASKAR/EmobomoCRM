import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/customer_model.dart';
import 'dart:convert';

class CustomerService {
  final Dio dio;
  final GetStorage _box = GetStorage();

  CustomerService(this.dio);

  String? get token => _box.read('token');
  Options get _authOptions => Options(headers: {'Authorization': 'Bearer $token'});

  // Use full URLs for all endpoints (like EmployeeService)
  static const String fetchCustomersUrl = 'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/customer';
  static const String addCustomerUrl = 'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/customer';
  static const String updateCustomerUrl = 'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/customer';
  static const String deleteCustomerUrl = 'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/customer';
  static const String getCustomerByIdUrl = 'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/customer';

  Future<List<CustomerModel>> fetchCustomers() async {
    try {
      final res = await dio.get(
        fetchCustomersUrl,
        options: _authOptions,
      );
      dynamic responseData = res.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
          return [];
        }
      }
      if (responseData is Map && responseData.containsKey('data')) {
        var data = responseData['data'];
        // FIX: If data is a Map and has 'customers', use that
        if (data is Map && data.containsKey('customers')) {
          data = data['customers'];
        }
        if (data is String) {
          if (data.trim().isEmpty) {
            return [];
          }
          try {
            data = jsonDecode(data);
          } catch (e) {
            return [];
          }
        }
        if (data is List) {
          return data.map((e) {
            if (e is Map<String, dynamic>) {
              return CustomerModel.fromJson(e);
            } else if (e is Map) {
              return CustomerModel.fromJson(Map<String, dynamic>.from(e));
            } else {
              return null;
            }
          }).whereType<CustomerModel>().toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('❗ Dio error: '+(e.response?.statusCode?.toString() ?? 'unknown'));
      print('Response: '+(e.response?.data?.toString() ?? 'no data'));
      return [];
    } catch (e) {
      print('❗ Unexpected error: $e');
      return [];
    }
  }

  Future<CustomerModel?> getCustomerById(String id) async {
    try {
      final res = await dio.get('$getCustomerByIdUrl/$id', options: _authOptions);
      dynamic responseData = res.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
        } catch (e) {
          return null;
        }
      }
      if (responseData is Map && responseData.containsKey('data')) {
        var data = responseData['data'];
        if (data is Map<String, dynamic>) {
          return CustomerModel.fromJson(data);
        } else if (data is Map) {
          return CustomerModel.fromJson(Map<String, dynamic>.from(data));
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on DioException catch (e) {
      print('❗ Dio error: '+(e.response?.statusCode?.toString() ?? 'unknown'));
      print('Response: '+(e.response?.data?.toString() ?? 'no data'));
      return null;
    } catch (e) {
      print('❗ Unexpected error: $e');
      return null;
    }
  }

  Future<bool> addCustomer(CustomerModel customer) async {
    try {
      final res = await dio.post(
        addCustomerUrl,
        data: customer.toJson(),
        options: _authOptions,
      );
      if (res.statusCode == 201 || res.statusCode == 200) {
        return true;
      } else {
        print('❗ Unexpected status code: ${res.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('❗ Dio error: '+(e.response?.statusCode?.toString() ?? 'unknown'));
      print('Response: '+(e.response?.data?.toString() ?? 'no data'));
      return false;
    } catch (e) {
      print('❗ Unexpected error: $e');
      return false;
    }
  }

  Future<bool> updateCustomer(CustomerModel customer) async {
    try {
      final res = await dio.put(
        '$updateCustomerUrl/${customer.id}',
        data: customer.toJson(),
        options: _authOptions,
      );
      if (res.statusCode == 200) {
        return true;
      } else {
        print('❗ Unexpected status code: ${res.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('❗ Dio error: '+(e.response?.statusCode?.toString() ?? 'unknown'));
      print('Response: '+(e.response?.data?.toString() ?? 'no data'));
      return false;
    } catch (e) {
      print('❗ Unexpected error: $e');
      return false;
    }
  }

  Future<bool> deleteCustomer(String id) async {
    try {
      final res = await dio.delete(
        '$deleteCustomerUrl/$id',
        options: _authOptions,
      );
      if (res.statusCode == 200) {
        return true;
      } else {
        print('❗ Unexpected status code: ${res.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      print('❗ Dio error: '+(e.response?.statusCode?.toString() ?? 'unknown'));
      print('Response: '+(e.response?.data?.toString() ?? 'no data'));
      return false;
    } catch (e) {
      print('❗ Unexpected error: $e');
      return false;
    }
  }
}