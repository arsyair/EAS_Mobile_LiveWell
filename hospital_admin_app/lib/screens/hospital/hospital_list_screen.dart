import 'package:flutter/material.dart';
import '../../services/hospital_service.dart';

class HospitalListScreen extends StatefulWidget {
  @override
  _HospitalListScreenState createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen> {
  final HospitalService _hospitalService = HospitalService();
  List<dynamic> _hospitals = [];
  List<dynamic> _filteredHospitals = [];
  String _selectedProvince = "Semua Provinsi";

  @override
  void initState() {
    super.initState();
    _fetchHospitals();
  }

  Future<void> _fetchHospitals() async {
    try {
      final hospitals = await _hospitalService.getHospitals();
      setState(() {
        _hospitals = hospitals;
        _filteredHospitals = hospitals;
      });
    } catch (e) {
      print("Error fetching hospitals: $e");
    }
  }

  void _filterHospitals(String province) {
    setState(() {
      _selectedProvince = province;
      if (province == "Semua Provinsi") {
        _filteredHospitals = _hospitals;
      } else {
        _filteredHospitals = _hospitals
            .where((hospital) =>
                hospital["province"].toString().toLowerCase() ==
                province.toLowerCase())
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provinces = [
      "Semua Provinsi",
      ..._hospitals.map((hospital) => hospital["province"]).toSet().toList()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Data Rumah Sakit"),
        backgroundColor: Color(0xFF001F54),
      ),
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Dropdown Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<String>(
              value: _selectedProvince,
              decoration: InputDecoration(
                labelText: "Filter by Province",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: provinces.map((province) {
                return DropdownMenuItem<String>(
                  value: province,
                  child: Text(province),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _filterHospitals(value);
              },
            ),
          ),
          // List of Hospitals
          Expanded(
            child: _filteredHospitals.isEmpty
                ? Center(child: Text("No hospitals found."))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: _filteredHospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = _filteredHospitals[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor:
                                  Color(0xFF001F54).withOpacity(0.1),
                              child: Icon(Icons.local_hospital,
                                  color: Color(0xFF001F54)),
                            ),
                            title: Text(
                              hospital["name"] ?? "Unknown",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(hospital["address"] ?? "No Address"),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.phone, size: 16, color: Colors.grey),
                                Text(
                                  hospital["phone"] ?? "-",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
