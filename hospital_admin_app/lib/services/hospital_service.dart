import 'dart:convert';
import 'package:http/http.dart' as http;

class HospitalService {
  final String apiUrl = "https://dekontaminasi.com/api/id/covid19/hospitals";

  Future<List<dynamic>> getHospitals() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load hospitals");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}
