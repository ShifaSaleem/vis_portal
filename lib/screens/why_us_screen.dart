import 'package:flutter/material.dart';

import '../models/award.dart';
import '../models/company.dart';
import '../services/company_service.dart';
import '../theme/app_theme.dart';

class WhyUsScreen extends StatefulWidget {
  const WhyUsScreen({super.key});

  @override
  State<WhyUsScreen> createState() => _WhyUsScreenState();
}

class _WhyUsScreenState extends State<WhyUsScreen> {
  late Company _companyDetails;
  List<Award> awards = [];

  @override
  void initState() {
    super.initState();
    fetchCompanyDetails();
  }

  Future<void> fetchCompanyDetails() async {
    setState(() async {
      _companyDetails = (await CompanyService().getCompanyDetails())!;
      awards = _companyDetails.awards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Why Choose Us',
          style: headerText24(),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Section
            Text(
              'Introduction',
              style: headerText16(),
            ),
            SizedBox(height: 10),
            Text(
              _companyDetails.about,
              style: bodyText14(),
            ),

            // Key Differentiators
            SizedBox(height: 20),
            Text(
              'Key Differentiators',
              style: headerText16(),
            ),
            SizedBox(height: 10),
            Text(
              _companyDetails.mission,
              style: bodyText14(),
            ),

            // Client Success Stories
            SizedBox(height: 20),
            Text(
              'Client Success Stories',
              style: headerText18(),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _companyDetails.projects.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:
                      Image.network(_companyDetails.projects[index].thumbnail),
                  title: Text(_companyDetails.projects[index].title,
                      style: headerText16()),
                  subtitle: Text(_companyDetails.projects[index].description,
                      style: bodyText14()),
                );
              },
            ),

            // Awards and Recognitions
            SizedBox(height: 20),
            Text(
              'Awards and Recognitions',
              style: headerText18(),
            ),
            SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: awards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(awards[index].title),
                  subtitle: Text(awards[index].description),
                  trailing: Text(awards[index].awardDate as String),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
