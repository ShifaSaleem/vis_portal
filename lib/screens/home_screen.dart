import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vis_portal/providers/auth_provider.dart';
import 'package:vis_portal/screens/contact_screen.dart';
import 'package:vis_portal/screens/profile_screen.dart';
import 'package:vis_portal/screens/why_us_screen.dart';
import '../components/button.dart';
import '../models/company.dart';
import '../models/project.dart';
import '../models/service.dart';
import '../models/social_media_link.dart';
import '../models/testimonial.dart';
import '../screens/job_vacancies_screen.dart';
import '../screens/services_screen.dart';
import '../models/users.dart';
import '../services/company_service.dart';
import '../theme/app_theme.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List screens = [
    HomeScreenWidget(),
    ServicesScreen(),
    JobVacanciesScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: iconColor,
          selectedLabelStyle: bodyText10(),
          unselectedLabelStyle: bodyText10(),
          onTap: (value) {
            setState(() => currentIndex = value);
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.design_services), label: 'Services'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service_rounded), label: 'Jobs'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
      body: screens[currentIndex],
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  User user = AuthProvider().getProfile() as User;
  late Future<Company?> _companyDetails;
  late List<Project> _projects;
  late List<Testimonial> _testimonials;
  late List<Service> _services;
  late List<SocialMediaLink> _socialLinks;

  @override
  void initState() {
    super.initState();
    _companyDetails = CompanyService().getCompanyDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 140,
          backgroundColor: primaryColor,
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome to Vis Portal',
                style: headerText24().copyWith(color: textLightColor)),
            const SizedBox(height: 2),
            Text(user.name,
                style: bodyText14().copyWith(color: textLight1Color)),
          ]),
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
        body: FutureBuilder<Company?>(
            future: _companyDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data != null) {
                final company = snapshot.data!;

                // Separate lists into their respective variables
                _projects = company.projects;
                _testimonials = company.testimonials;
                _services = company.services;
                _socialLinks = company.socialLinks;
                return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(children: [
                        Stack(
                          children: [
                            // Banner Image
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Image.network(
                                company.banner,
                                fit: BoxFit.cover,
                                height: 140,
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: 20,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage:
                                          NetworkImage(company.logo),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(company.name, style: headerText18()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        // Abut US
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About Us', style: headerText18()),
                            SizedBox(height: 10),
                            Text(company.about, style: bodyText14()),
                            SizedBox(height: 10),
                            Text('Mission: ' + company.mission,
                                style: bodyText14()),
                            Row(children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const WhyUsScreen()));
                                  },
                                  child: Text('Why Us?', style: headerText14())),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => const ContactScreen()));
                                  },
                                  child: Text('Contact Now', style: headerText14()))
                            ]),
                          ],
                        ),
                        SizedBox(height: 14),
                        //Services overview

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Services', style: headerText18()),
                            SizedBox(height: 10),
                            ListView.builder(
                                scrollDirection: Axis.horizontal, // Set the scroll direction to horizontal
                                itemCount: _services.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width:
                                        200, // Set a fixed width for each item in the horizontal list
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0), // Add some margin between items
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 40,
                                        backgroundImage:
                                            NetworkImage(_services[index].icon),
                                      ),
                                      title: Text(_services[index].title),
                                      subtitle:
                                          Text(_services[index].description),
                                      onTap: () {
                                        // Navigate to service detail
                                      },
                                    ),
                                  );
                                }),
                          ],
                        ),
                        SizedBox(height: 14),
                        // Testimonials
                        Column(
                          children: [
                            Text('Testimonials', style: headerText18()),
                            SizedBox(height: 10),
                            CarouselSlider(
                              options: CarouselOptions(height: 200.0),
                              items: _testimonials.map((testimonial) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                  testimonial.avatar),
                                            ),
                                            SizedBox(height: 10),
                                            Text(testimonial.clientName,
                                                style: headerText14()),
                                            SizedBox(height: 4),
                                            Text(testimonial.quote,
                                                style: bodyText12()),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        // Projects

                        Column(
                          children: [
                            Text('Testimonials', style: headerText18()),
                            SizedBox(height: 10),
                            GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              padding: EdgeInsets.all(14),
                              itemCount: _projects.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Column(
                                    children: [
                                      Container(
                                          height: 160,
                                          child: Image.network(
                                            _projects[index].thumbnail,
                                            fit: BoxFit.fill,
                                          )),
                                      SizedBox(height: 10),
                                      Text(_projects[index].title,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(height: 4),
                                      Text(_projects[index].extraDescription,
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 14),
                        // Footer
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Contact Us', style: headerText18()),
                            SizedBox(height: 10),
                            Text('Address: ' + company.contactAddress),
                            SizedBox(height: 4),
                            Text('Phone: ' + company.contactPhone),
                            SizedBox(height: 4),
                            Text('Email: ' + company.contactEmail),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.facebook),
                                    onPressed: () {
                                      /* Navigate to social media */
                                    }),
                                // Add more social media icons as needed
                              ],
                            ),
                            DefaultButton(
                              onPressed: () {/* Signup for newsletter */},
                              labelText: 'Signup for Newsletter',
                              textStyle: headerText16(),
                              backgroundColor: primaryColor,
                            ),
                          ],
                        )
                      ])),
                );
              } else {
                return Center(
                    child: Text('No data available', style: bodyText16()));
              }
            }));
  }
}
