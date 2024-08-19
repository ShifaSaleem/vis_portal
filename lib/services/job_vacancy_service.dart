import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_vacancy.dart';
import '../api_config.dart';

class JobVacancyService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<JobVacancy>> getJobVacancies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/job-vacancies'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => JobVacancy.fromJson(item)).toList();
    } else {
      // Handle error
      throw Exception('Failed to load vacancies');
    }
  }
}
