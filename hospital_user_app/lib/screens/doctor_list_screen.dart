import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final ApiService apiService = ApiService();
  late Future<List> doctors;

  @override
  void initState() {
    super.initState();
    doctors = apiService.getDoctors(); // Memuat data dokter dari API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List>(
        future: doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No doctors found'));
          }

          // Data dokter berhasil diambil
          final doctorList = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: doctorList.length,
            itemBuilder: (context, index) {
              final doctor = doctorList[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(
                      doctor['name'][0], // Inisial nama dokter
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    doctor['name'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Specialization: ${doctor['specialization']}'),
                      Text('Available: ${doctor['availability_time']}'),
                    ],
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
