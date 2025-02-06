import 'package:dio/dio.dart';

class UserServices {
  final dio = Dio();
  final String baseUrl = 'http://10.0.2.2:3000/api/';
  registerUser(String userdata) async {
    final response = await dio.post("${baseUrl}register", data: userdata);
    return response;
  }

  loginUser(String userdata) async {
    final response = await dio.post("${baseUrl}login", data: userdata);
    return response;
  }
}
