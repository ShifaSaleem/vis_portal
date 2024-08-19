import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vis_portal/providers/auth_provider.dart';

import '../components/button.dart';
import '../components/input_fields.dart';
import '../input_validators/input_validators.dart';
import '../models/project.dart';
import '../models/users.dart';
import '../services/user_service.dart';
import '../theme/app_theme.dart';

import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'notifications_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  late User user;
  File? _image;

  late Future<Map<String, dynamic>> _profileData;
  @override
  void initState() {
    super.initState();
    user = _authProvider.getProfile() as User;
    _profileData = UserService().getProfileData();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Profile',
              style: headerText24().copyWith(color: textLightColor)),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationsScreen()));
              },
            ),
          ],
        ),
        body: FutureBuilder<Map<String, dynamic>>(
            future: _profileData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No data available'));
              } else {
                final user = snapshot.data!['user'];
                final projects = snapshot.data!['projects'] as List<Project>;
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 100, 20, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Center(
                                    child: _image != null
                                        ? CircleAvatar(
                                            radius: 80,
                                            backgroundImage: FileImage(_image!),
                                          )
                                        : CircleAvatar(
                                            radius: 80,
                                            backgroundImage:
                                                NetworkImage(user['profile_image']),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: _pickImage,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white12,
                                    blurRadius: 14,
                                    offset: Offset.fromDirection(4)
                                  )
                                ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['name'], style: bodyText14()),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white12,
                                        blurRadius: 14,
                                        offset: Offset.fromDirection(4)
                                    )
                                  ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(user['email'], style: bodyText14()),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Submitted Projects',
                              style: headerText18(),
                            ),
                            IconButton(onPressed: (){

                            },
                                icon: Icon(Icons.add, color: primaryColor))
                          ],
                        ),
                        SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(projects[index].title),
                              subtitle: Text(projects[index].description),
                            );
                          },
                        ),
                        SizedBox(height: 24),
                        DefaultButton(
                            labelText: 'Edit Profile',
                            textStyle:
                                headerText16().copyWith(color: textLightColor),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfileScreen(user: user)));
                            },
                            backgroundColor: primaryColor),
                        SizedBox(height: 16),
                        OutlineButton(
                            labelText: 'Change Password',
                            textStyle:
                                headerText16().copyWith(color: primaryColor),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ChangePasswordScreen()));
                            },
                            borderColor: primaryColor),
                        SizedBox(height: 16),
                        DefaultButton(
                            labelText: 'Logout',
                            textStyle:
                                headerText16().copyWith(color: textLightColor),
                            onPressed: () {
                              _authProvider.logout(context);
                            },
                            backgroundColor: primaryColor),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
