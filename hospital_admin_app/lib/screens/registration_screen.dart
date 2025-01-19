import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _registrations = [];
  String _selectedStatus = "pending"; // Default filter status

  @override
  void initState() {
    super.initState();
    _fetchRegistrations();
  }

  // Fetch registrations from API
  Future<void> _fetchRegistrations() async {
    try {
      final registrations = await _apiService.getRegistrations();
      setState(() {
        _registrations = registrations;
      });
    } catch (e) {
      print("Error fetching registrations: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch registrations.')),
      );
    }
  }

  // Update registration status
  Future<void> _updateStatus(int registrationId, String status) async {
    try {
      // Validasi status sebelum mengirim
      if (!["pending", "approved", "rejected"].contains(status)) {
        throw Exception("Invalid status value");
      }

      await _apiService.updateRegistrationStatus(registrationId, status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration status updated to $status.')),
      );
      _fetchRegistrations(); // Refresh data setelah update
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update registration status.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter registrations by selected status
    final filteredRegistrations = _registrations
        .where((reg) =>
            reg['status'] != null &&
            reg['status'].toString().toLowerCase() == _selectedStatus.toLowerCase())
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrations"),
        backgroundColor: Color(0xFF001F54), // Navy Blue
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Dropdown for status filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: ["pending", "approved", "rejected"].map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
            ),
          ),
          // List of registrations
          Expanded(
            child: filteredRegistrations.isEmpty
                ? Center(
                    child: Text(
                      "No registrations found for the selected status.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredRegistrations.length,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final registration = filteredRegistrations[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(16),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor:
                                _selectedStatus == "approved"
                                    ? Colors.green.withOpacity(0.2)
                                    : _selectedStatus == "rejected"
                                        ? Colors.red.withOpacity(0.2)
                                        : Colors.yellow.withOpacity(0.2),
                            child: Icon(
                              _selectedStatus == "approved"
                                  ? Icons.check
                                  : _selectedStatus == "rejected"
                                      ? Icons.close
                                      : Icons.pending,
                              color: _selectedStatus == "approved"
                                  ? Colors.green
                                  : _selectedStatus == "rejected"
                                      ? Colors.red
                                      : Colors.orange,
                            ),
                          ),
                          title: Text(
                            registration['user_name'] ?? "Unknown User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hospital: ${registration['hospital'] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Complain: ${registration['complain'] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          trailing: _selectedStatus == "pending"
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.check, color: Colors.green),
                                      onPressed: () => _updateStatus(
                                          registration['registration_id'], "approved"),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, color: Colors.red),
                                      onPressed: () => _updateStatus(
                                          registration['registration_id'], "rejected"),
                                    ),
                                  ],
                                )
                              : Text(
                                  registration['status']
                                          ?.toString()
                                          .toUpperCase() ??
                                      "-",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: registration['status'] == "approved"
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
