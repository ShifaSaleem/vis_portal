class Project {
  final String title;
  final String description;
  final String thumbnail;
  final String extraDescription;
  final String userFile;
  final String companyFile;
  final String externalLink;
  final String status;

  Project({
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.extraDescription,
    required this.userFile,
    required this.companyFile,
    required this.externalLink,
    required this.status
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      extraDescription: json['extra_description'],
      userFile: json['user_file'],
      companyFile: json['company_file'],
      externalLink: json['external_link'],
      status: json['status'],
    );
  }
}