

class JobVacancy {
  final String title;
  final String description;
  final String requirements;
  final String applicationLink;
  final String benefits;

  JobVacancy({
    required this.title,
    required this.description,
    required this.requirements,
    required this.applicationLink,
    required this.benefits
  });

  factory JobVacancy.fromJson(Map<String, dynamic> json) {
    return JobVacancy(
      title: json['title'],
      description: json['description'],
      requirements: json['requirements'],
      applicationLink: json['application_link'],
      benefits: json['benefits'],
    );
  }
}