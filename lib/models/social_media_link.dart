class SocialMediaLink {
  final String name;
  final String link;

  SocialMediaLink({required this.name, required this.link});

  factory SocialMediaLink.fromJson(Map<String, dynamic> json) {
    return SocialMediaLink(
      name: json['name'],
      link: json['link'],
    );
  }
}