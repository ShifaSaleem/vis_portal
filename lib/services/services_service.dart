import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service.dart';
import '../api_config.dart';

class ServicesService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<Service>> getServices() async {
    final response = await http.get(
      Uri.parse('$baseUrl/services'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<Service?> getServiceDetails(Service service) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/{$service}'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Service.fromJson(responseData);
    } else {
      // Handle error
      return null;
    }
  }
}
