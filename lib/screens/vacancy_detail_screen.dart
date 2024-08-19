import 'package:flutter/material.dart';

import '../components/button.dart';
import '../models/job_vacancy.dart';
import '../theme/app_theme.dart';
import 'apply_now_screen.dart';

class VacancyDetailScreen extends StatefulWidget {
  final JobVacancy vacancy;
  const VacancyDetailScreen({super.key, required this.vacancy});

  @override
  State<VacancyDetailScreen> createState() => _VacancyDetailScreenState();
}

class _VacancyDetailScreenState extends State<VacancyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vacancy.title, style: headerText24()),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description',
              style: headerText18(),
            ),
            Text(widget.vacancy.description, style: bodyText14()),
            SizedBox(height: 20),
            Text(
              'Requirements',
              style: headerText18(),
            ),
            Text(widget.vacancy.requirements, style: bodyText14()),
            SizedBox(height: 20),
            Text(
              'Benefits',
              style: headerText18(),
            ),
            Text(widget.vacancy.benefits, style: bodyText14()),
            SizedBox(height: 20),
            DefaultButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplyNowScreen(
                      url: widget.vacancy.applicationLink,
                    ),
                  ),
                );
              },
              labelText: 'Apply Now',
              textStyle: headerText16(),
              backgroundColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
