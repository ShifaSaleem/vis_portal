import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/project.dart';
import '../models/service.dart';
import '../services/project_service.dart';
import '../services/services_service.dart';
import '../theme/app_theme.dart';

class SubmitProjectScreen extends StatefulWidget {
  const SubmitProjectScreen({super.key});

  @override
  State<SubmitProjectScreen> createState() => _SubmitProjectScreenState();
}

class _SubmitProjectScreenState extends State<SubmitProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serviceNameController = TextEditingController();
  File? _selectedFile;
  late Project project;
  late List<Service> _services;
  String? _selectedService;

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

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitProject() async {
    late final response;
    if (_formKey.currentState!.validate()) {
      if (_selectedFile != null) {
        response = ProjectService().submitNewProject(
            _nameController.text,
            _descriptionController.text,
            _selectedFile!,
            _serviceNameController.text);
      }
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Project submitted successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit project')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit New Project', style: headerText24()),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              DefaultTextField(
                prefixIcon: Icon(Icons.design_services),
                labelText: 'Project Name',
                hintText: 'Enter Project Name',
                textInputType: TextInputType.name,
                controller: _nameController,
                validator: validateName,
              ),
              SizedBox(height: 16),
              DefaultTextField(
                prefixIcon: Icon(Icons.description),
                labelText: 'Description',
                hintText: 'Enter Project Description',
                textInputType: TextInputType.text,
                controller: _descriptionController,
                validator: validateEmail,
              ),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedService,
                  items: _services.map((Service service) {
                    return DropdownMenuItem<String>(
                      value: service.title,
                      child: Text(service.title, style: bodyText10()),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Services',
                    labelStyle: bodyText12(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedService = newValue;
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              _selectedFile == null
                  ? Text('No file selected.')
                  : Container(child: Image.file(_selectedFile!)),
              OutlineButton(
                onPressed: _pickFile,
                labelText: 'Select File to Upload',
                textStyle: headerText16().copyWith(color: primaryColor),
                borderColor: primaryColor,
              ),
              SizedBox(height: 16),
              DefaultButton(
                onPressed: _submitProject,
                labelText: 'Submit Project',
                textStyle: headerText16().copyWith(color: textLightColor),
                backgroundColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
