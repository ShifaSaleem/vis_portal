import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/service.dart';
import '../api_config.dart';

class ProjectService {
  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;

  Future<List<Project>> getServiceProjects(Service service) async {
    final response = await http.get(
      Uri.parse('$baseUrl/services/{$service}/projects'),
      headers: await config.getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Project.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<http.StreamedResponse> submitNewProject(String title, String description, File userFile, String serviceName) async {
    final url = Uri.parse('$baseUrl/user/submit-project');
    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(await config.getHeadersForMultipart())
      ..fields['name'] = title
      ..fields['description'] = description
      ..fields['service_name'] = serviceName
      ..files.add(await http.MultipartFile.fromPath('user_file', userFile.path));

    return await request.send();
  }

}
