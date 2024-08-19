
class Award {
  final String title;
  final String description;
  final DateTime awardDate;


  Award({required this.title, required this.description, required this.awardDate});

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      title: json['title'],
      description: json['description'],
      awardDate: json['award_date'],
    );
  }
}