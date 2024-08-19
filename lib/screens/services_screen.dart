import 'package:flutter/material.dart';

import '../models/project.dart';
import '../models/service.dart';
import '../services/project_service.dart';
import '../services/services_service.dart';
import '../theme/app_theme.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedIndex = 0;
  late List<Service> _services;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  _fetchServices() {
    setState(() async {
      _services = await ServicesService().getServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: _services.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Our Services', style: headerText24()),
            bottom: TabBar(
              isScrollable: true,
              tabs: _services.map((service) => Tab(text: service.title)).toList(),
            ),
          ),
          body: TabBarView(
            children: _services.map((service) {
              return ServiceDetailsTab(service: service);
            }).toList(),
          ),
        ),
    );
  }
}

class ServiceDetailsTab extends StatelessWidget {
  final Service service;

  ServiceDetailsTab({required this.service});

  late List<Project> _projects;

  @override
  Widget build(BuildContext context) {
    _projects = ProjectService().getServiceProjects(service) as List<Project>;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              service.title,
              style: headerText16(),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(service.description, style: bodyText14()),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Related Projects',
              style: headerText18(),
            ),
          ),
          ListView.builder(
            itemCount: _projects.length,
            itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(_projects[index].thumbnail),
              title: Text(_projects[index].title, style: headerText16()),
              subtitle: Text(_projects[index].description, style: bodyText14()),
            );
          },

          )


        ],
      ),
    );
  }
}
