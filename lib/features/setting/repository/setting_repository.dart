import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api_error.dart';

class SettingRepository{

  Future<Map<String, dynamic>> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      final Map<String, dynamic> data = {
        'oldPassword': oldPassword,
        'newPassword': newPassword
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('accessToken');

      const apiUrl =
          'https://invite.iotsense.in/api/v1/users/change-password';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );

      final jsonBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonBody;
      } else {
        throw ApiError(
            statusCode: response.statusCode,
            message: jsonDecode(response.body)['message']);
      }
    } catch (e) {
      if (e is ApiError) {
        throw ApiError(statusCode: e.statusCode, message: e.message);
      } else {
        throw ApiError(message: e.toString());
      }
    }
  }

}