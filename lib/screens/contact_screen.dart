import 'package:flutter/material.dart';
import '../api_config.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/company.dart';
import '../services/company_service.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Company _companyDetails;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  ApiConfig config = ApiConfig();
  final String baseUrl = ApiConfig().baseUrl;
  @override
  void initState() {
    super.initState();
    _companyDetails = CompanyService().getCompanyDetails() as Company;
  }

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await http.post(
        Uri.parse('$baseUrl/contact-form-submissions'),
        headers: await config.getHeaders(),
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'message': _messageController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Your message has been sent successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to send your message. Please try again.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: headerText24(),
        ),
       leading: IconButton(
           onPressed: () {
             Navigator.pop(context);
           },
           icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DefaultTextField(
                    prefixIcon: Icon(Icons.person),
                    labelText: 'Full Name',
                    hintText: 'Enter Full Name',
                    textInputType: TextInputType.name,
                    controller: _nameController,
                    validator: validateName,
                  ),
                  SizedBox(height: 16),
                  DefaultTextField(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Email',
                    hintText: 'username@gmail.com',
                    textInputType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: validateEmail,
                  ),
                  SizedBox(height: 16),
                  DefaultTextField(
                    prefixIcon: Icon(Icons.phone),
                    labelText: 'Phone Number',
                    hintText: '+1 23456789',
                    textInputType: TextInputType.phone,
                    controller: _phoneController,
                    validator: validatePhoneNumber,
                  ),
                  SizedBox(height: 16),
                  DefaultTextField(
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Message',
                    hintText: 'Enter your message',
                    textInputType: TextInputType.text,
                    controller: _messageController,
                    validator: validateName,
                  ),
                  SizedBox(height: 20),
                  DefaultButton(
                    onPressed: submitForm,
                    labelText: 'Send Message',
                    textStyle: headerText16(),
                    backgroundColor: primaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            // Contact Information
            Text(
              'Contact Information',
              style: headerText18(),
            ),
            SizedBox(height: 10),
            Text(_companyDetails.contactAddress),
            Text(_companyDetails.contactPhone),
            Text(_companyDetails.contactEmail),
            SizedBox(height: 20),
            // Map Integration
            Text(
              'Our Location',
              style: headerText18(),
            ),
            SizedBox(height: 10),
            Container(
              height: 200,
              child: InkWell(
                onTap: () async {
                  final query =
                      Uri.encodeComponent(_companyDetails.contactAddress);
                  final url =
                      'https://www.google.com/maps/search/?api=1&query=$query';
                  if (await canLaunchUrl(url as Uri)) {
                    await launchUrl(url as Uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Image.network(
                  'https://maps.googleapis.com/maps/api/staticmap?center=${_companyDetails.contactAddress}&zoom=15&size=600x300&key=YOUR_API_KEY',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
