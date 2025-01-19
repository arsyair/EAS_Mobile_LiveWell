import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DoctorListScreen extends StatefulWidget {
  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _doctors;

  @override
  void initState() {
    super.initState();
    _refreshDoctors();
  }

  Future<void> _refreshDoctors() async {
    setState(() {
      _doctors = apiService.getDoctors();
    });
  }

  void _showDoctorForm({Map<String, dynamic>? doctor}) {
    final _formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: doctor?['name'] ?? '');
    final specializationController =
        TextEditingController(text: doctor?['specialization'] ?? '');
    final availabilityTimeController =
        TextEditingController(text: doctor?['availability_time'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            doctor == null ? "Add Doctor" : "Edit Doctor",
            style: TextStyle(color: Color(0xFF001F54)),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: specializationController,
                  decoration: InputDecoration(labelText: "Specialization"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter specialization";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: availabilityTimeController,
                  decoration: InputDecoration(labelText: "Availability Time"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter availability time";
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF001F54)),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  if (doctor == null) {
                    await apiService.createDoctor(
                      nameController.text,
                      specializationController.text,
                      availabilityTimeController.text,
                    );
                  } else {
                    await apiService.updateDoctor(
                      doctor['doctor_id'],
                      nameController.text,
                      specializationController.text,
                      availabilityTimeController.text,
                    );
                  }
                  Navigator.pop(context, true); // Return true to refresh Dashboard
                  _refreshDoctors();
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteDoctor(int doctorId) async {
    await apiService.deleteDoctor(doctorId);
    Navigator.pop(context, true); // Return true to refresh Dashboard
    _refreshDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Doctors"),
        backgroundColor: Color(0xFF001F54),
      ),
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<List<dynamic>>(
        future: _doctors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No doctors found."));
          }

          final doctors = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF001F54).withOpacity(0.2),
                      child: Icon(Icons.local_hospital, color: Color(0xFF001F54)),
                    ),
                    title: Text(
                      doctor['name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${doctor['specialization']} - ${doctor['availability_time']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.green),
                          onPressed: () => _showDoctorForm(doctor: doctor),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDoctor(doctor['doctor_id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF001F54),
        onPressed: () => _showDoctorForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
