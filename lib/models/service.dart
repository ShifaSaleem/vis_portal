import 'package:vis_portal/models/project.dart';

class Service {
  final String title;
  final String description;
  final String icon;
  final List<Project>? projects;

  Service({required this.title, required this.description, required this.icon, this.projects});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      projects: (json['projects'] as List).map((i) => Project.fromJson(i)).toList(),
    );
  }
}