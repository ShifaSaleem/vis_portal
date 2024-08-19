import 'package:vis_portal/models/project.dart';
import 'package:vis_portal/models/service.dart';
import 'package:vis_portal/models/social_media_link.dart';
import 'package:vis_portal/models/testimonial.dart';
import 'award.dart';

class Company {
  final String name;
  final String logo;
  final String banner;
  final String mission;
  final String about;
  final String contactEmail;
  final String contactPhone;
  final String contactAddress;

  final List<Project> projects;
  final List<Testimonial> testimonials;
  final List<Service> services;
  final List<SocialMediaLink> socialLinks;
  final List<Award> awards;

  Company({
    required this.name,
    required this.logo,
    required this.banner,
    required this.mission,
    required this.about,
    required this.contactEmail,
    required this.contactPhone,
    required this.contactAddress,
    required this.projects,
    required this.testimonials,
    required this.services,
    required this.socialLinks,
    required this.awards
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['company']['name'],
      logo: json['company']['logo'],
      banner: json['company']['banner'],
      mission: json['company']['mission'],
      about: json['company']['about'],
      contactEmail: json['company']['contact_email'],
      contactPhone: json['company']['contact_phone'],
      contactAddress: json['company']['contact_address'],
      projects: (json['projects'] as List).map((i) => Project.fromJson(i)).toList(),
      testimonials: (json['testimonials'] as List).map((i) => Testimonial.fromJson(i)).toList(),
      services: (json['services'] as List).map((i) => Service.fromJson(i)).toList(),
      socialLinks: (json['social_links'] as List).map((i) => SocialMediaLink.fromJson(i)).toList(),
      awards: (json['awards'] as List).map((i) => Award.fromJson(i)).toList(),
    );
  }
}
