import 'package:flutter/material.dart';
import 'package:vis_portal/screens/vacancy_detail_screen.dart';

import '../models/company.dart';
import '../models/job_vacancy.dart';
import '../services/company_service.dart';
import '../services/job_vacancy_service.dart';
import '../theme/app_theme.dart';

class JobVacanciesScreen extends StatefulWidget {
  const JobVacanciesScreen({super.key});

  @override
  State<JobVacanciesScreen> createState() => _JobVacanciesScreenState();
}

class _JobVacanciesScreenState extends State<JobVacanciesScreen> {
  List<JobVacancy> jobVacancies = [];
  late Company _companyDetails;

  @override
  void initState() {
    super.initState();
    _companyDetails = CompanyService().getCompanyDetails() as Company;
    fetchJobVacancies();
  }

  fetchJobVacancies() async {
    var vacancies = await JobVacancyService().getJobVacancies();
    setState(() {
      jobVacancies = vacancies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Vacancies', style: headerText24()),
      ),
      body: jobVacancies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jobVacancies.length,
              itemBuilder: (context, index) {
                var vacancy = jobVacancies[index];
                return ListTile(
                  leading: Image.network(_companyDetails.logo),
                  title: Text(
                    vacancy.title,
                    style: headerText16(),
                  ),
                  subtitle: Text(vacancy.description, style: bodyText14()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VacancyDetailScreen(
                          vacancy: vacancy,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
