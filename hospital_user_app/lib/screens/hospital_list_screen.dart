import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  late Future<List> hospitals;

  @override
  void initState() {
    super.initState();
    hospitals = fetchHospitals();
  }

  Future<List> fetchHospitals() async {
    final url = Uri.parse('https://dekontaminasi.com/api/id/covid19/hospitals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List allHospitals = json.decode(response.body);
      List filteredHospitals = allHospitals
          .where((hospital) => hospital['province'] == 'Jawa Barat')
          .toList();
      return filteredHospitals;
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospital List - Jawa Barat'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List>(
        future: hospitals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hospitals found in Jawa Barat'));
          }

          final hospitalList = snapshot.data!;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              itemCount: hospitalList.length,
              itemBuilder: (context, index) {
                final hospital = hospitalList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      hospital['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address: ${hospital['address']}'),
                        Text('Phone: ${hospital['phone'] ?? "Not Available"}'),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.blueAccent),
                    onTap: () {
                      Navigator.pop(context, hospital['name']);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
