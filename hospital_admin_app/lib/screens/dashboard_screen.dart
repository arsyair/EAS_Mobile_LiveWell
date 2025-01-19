import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../screens/user/user_list_screen.dart';
import '../screens/doctor/doctor_list_screen.dart';
import '../screens/hospital/hospital_list_screen.dart';
import 'registration_screen.dart';
import 'about_us_screen.dart';
import '../screens/chat/chat_list_screen.dart'; // Pastikan file ini sudah dibuat

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int userCount = 0;
  int doctorCount = 0;
  Map<String, int> hospitalData = {}; // Data untuk grafik rumah sakit

  @override
  void initState() {
    super.initState();
    _fetchCounts();
    _fetchHospitalData();
  }

  Future<void> _fetchCounts() async {
    try {
      final users = await ApiService().getUsers();
      final doctors = await ApiService().getDoctors();
      setState(() {
        userCount = users.length;
        doctorCount = doctors.length;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _fetchHospitalData() async {
    try {
      final registrations = await ApiService().getRegistrations();
      Map<String, int> hospitalCounts = {};

      for (var registration in registrations) {
        if (registration['status'] == 'approve') {
          String hospital = registration['hospital'] ?? 'Unknown';
          hospitalCounts[hospital] = (hospitalCounts[hospital] ?? 0) + 1;
        }
      }

      setState(() {
        hospitalData = hospitalCounts;
      });
    } catch (e) {
      print('Error fetching hospital data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFF001F54), // Navy Blue
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/images/profile.jpg'),
                          ),
                          IconButton(
                            icon: Icon(Icons.info_outline, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AboutUsScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Admin",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // PageView for Slidable Charts
                      Container(
                        height: 200,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: PageView(
                          children: [
                            _buildBarChart(),
                            _buildHospitalChart(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Title above buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Manage Data",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 1.0, left: 16.0, right: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildDashboardCard(
                    context,
                    label: "Manage Users",
                    icon: Icons.person,
                    color: Colors.blueAccent,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserListScreen()),
                      );
                      if (result == true) {
                        _fetchCounts(); // Refresh grafik jika data berubah
                      }
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    label: "Manage Doctors",
                    icon: Icons.local_hospital,
                    color: Colors.green,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DoctorListScreen()),
                      );
                      if (result == true) {
                        _fetchCounts(); // Refresh grafik jika data berubah
                      }
                    },
                  ),
                  _buildDashboardCard(
                    context,
                    label: "Hospitals",
                    icon: Icons.local_pharmacy,
                    color: const Color.fromARGB(255, 233, 91, 91),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HospitalListScreen()),
                    ),
                  ),
                  _buildDashboardCard(
                    context,
                    label: "Registrations",
                    icon: Icons.assignment,
                    color: Colors.orange,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF001F54), // Navy Blue
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatListScreen()),
          );
        },
        child: Icon(Icons.chat, size: 28, color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  // Grafik pertama
  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        maxY: (userCount > doctorCount ? userCount : doctorCount).toDouble() + 5,
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: userCount.toDouble(),
                width: 20,
                color: Colors.blue,
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(
                toY: doctorCount.toDouble(),
                width: 20,
                color: Colors.green,
              ),
            ],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 1:
                    return Text('Users');
                  case 2:
                    return Text('Doctors');
                  default:
                    return Text('');
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  // Grafik rumah sakit
  Widget _buildHospitalChart() {
    if (hospitalData.isEmpty) {
      return Center(
        child: Text(
          "No data available",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    final List<String> hospitalNames = hospitalData.keys.toList();
    final List<int> approvalCounts = hospitalData.values.toList();

    return BarChart(
      BarChartData(
        maxY: approvalCounts.reduce((a, b) => a > b ? a : b).toDouble() + 2,
        barGroups: List.generate(
          hospitalNames.length,
          (index) => BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: approvalCounts[index].toDouble(),
                width: 20,
                color: Colors.orange,
              ),
            ],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 100,
              getTitlesWidget: (double value, TitleMeta meta) {
                final index = value.toInt();
                if (index >= 0 && index < hospitalNames.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      hospitalNames[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey),
        ),
        gridData: FlGridData(show: false),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context,
      {required String label,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 30, color: color),
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}