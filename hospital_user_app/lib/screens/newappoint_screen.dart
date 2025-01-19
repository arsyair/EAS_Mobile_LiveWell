import 'package:flutter/material.dart';
import '../services/hospital_service.dart';
import '../services/api_service.dart';
import 'hospital_list_screen.dart';

class NewAppointmentScreen extends StatefulWidget {
  final int userId;
  final String userName;

  NewAppointmentScreen({required this.userId, required this.userName});

  @override
  _NewAppointmentScreenState createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final HospitalService _hospitalService = HospitalService();
  final ApiService _apiService = ApiService();

  List<String> _hospitalNames = [];
  String? _selectedHospital;
  final TextEditingController _complaintController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHospitalNames();
  }

  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  Future<void> _fetchHospitalNames() async {
    try {
      final names = await _hospitalService.fetchHospitalNames();
      setState(() {
        _hospitalNames = names;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching hospital names: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitRegistration() async {
    if (_selectedHospital == null || _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiService.createRegistrations(
        userId: widget.userId,
        userName: widget.userName,
        hospital: _selectedHospital!,
        complain: _complaintController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration submitted successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToHospitalList() async {
    final selectedHospital = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HospitalListScreen(),
      ),
    );
    if (selectedHospital != null) {
      setState(() {
        _selectedHospital = selectedHospital as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Registration'),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[50]!, Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blueAccent, Colors.lightBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi, ${widget.userName}!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Please fill out the form below to register for your hospital visit.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Dropdown for Hospital Selection
                      Text(
                        "Select Hospital",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        hint: Text('Choose a hospital'),
                        value: _selectedHospital,
                        isExpanded: true,
                        items: _hospitalNames.map((name) {
                          return DropdownMenuItem<String>(
                            value: name,
                            child: Text(name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedHospital = value;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Link to Hospital List
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: _navigateToHospitalList,
                          child: Text(
                            'View Hospital Details',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Complaint Text Field
                      Text(
                        "Your Complaint",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _complaintController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Enter your complaint',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitRegistration,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Submit Registration',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
