class Testimonial {
  final String clientName;
  final String clientCompany;
  final String quote;
  final String avatar;

  Testimonial({required this.clientName, required this.clientCompany, required this.quote, required this.avatar});

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      clientName: json['client_name'],
      clientCompany: json['client_company'],
      quote: json['quote'],
      avatar: json['avatar'],
    );
  }
}