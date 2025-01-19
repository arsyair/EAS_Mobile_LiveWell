import 'package:http/http.dart' as http;
import 'dart:convert';

  // Fungsi untuk mengambil data rumah sakit
  class HospitalService {
  Future<List<String>> fetchHospitalNames() async {
    final url = Uri.parse('https://dekontaminasi.com/api/id/covid19/hospitals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List allHospitals = json.decode(response.body);
      // Filter hanya untuk Jawa Barat
      List filteredHospitals = allHospitals
          .where((hospital) => hospital['province'] == 'Jawa Barat')
          .toList();
      return filteredHospitals.map((hospital) => hospital['name'] as String).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }
  }

