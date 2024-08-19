import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import '../api_config.dart';

class CompanyService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<Company?> getCompanyDetails() async {
    final response = await http.get(
      Uri.parse('$baseUrl/company/details'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return Company.fromJson(responseData);
    } else {
      // Handle error
      return null;
    }
  }
}
