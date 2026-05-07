import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api-test.khmail.cn/native-api';

  static Future<Map<String, dynamic>> get(String path, [Map<String, String>? params]) async {
    final query = <String, String>{'path': path, ...?params};
    final uri = Uri.parse('$baseUrl/index.php').replace(queryParameters: query);
    final res = await http.get(uri).timeout(const Duration(seconds: 20));
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
