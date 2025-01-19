import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.13:3000'; // Ganti sesuai IP server Anda

  // Fungsi untuk memeriksa response HTTP
  void _checkResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw Exception(
          'Request failed with status: ${response.statusCode}, body: ${response.body}');
    }
  }

  // **USERS**
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    _checkResponse(response);
    return json.decode(response.body);
  }

  Future<void> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );
    _checkResponse(response);
  }

  Future<void> updateUser(
      int userId, String name, String email, String password) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'name': name, 'email': email, 'password': password}),
    );
    _checkResponse(response);
  }

  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));
    _checkResponse(response);
  }

  // **DOCTORS**
  Future<List<dynamic>> getDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/doctors'));
    _checkResponse(response);
    return json.decode(response.body);
  }

  Future<void> createDoctor(
      String name, String specialization, String availabilityTime) async {
    final response = await http.post(
      Uri.parse('$baseUrl/doctors'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'specialization': specialization,
        'availability_time': availabilityTime,
      }),
    );
    _checkResponse(response);
  }

  Future<void> updateDoctor(int doctorId, String name, String specialization,
      String availabilityTime) async {
    final response = await http.put(
      Uri.parse('$baseUrl/doctors/$doctorId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'specialization': specialization,
        'availability_time': availabilityTime,
      }),
    );
    _checkResponse(response);
  }

  Future<void> deleteDoctor(int doctorId) async {
    final response = await http.delete(Uri.parse('$baseUrl/doctors/$doctorId'));
    _checkResponse(response);
  }

  // **REGISTRATIONS**
  // Fungsi untuk mendapatkan semua data registrations
  Future<List<dynamic>> getRegistrations() async {
    final response = await http.get(Uri.parse('$baseUrl/registrations'));
    _checkResponse(response);
    return json.decode(response.body);
  }

  // Fungsi untuk membuat data registration baru
  Future<void> createRegistration(
      int userId, String userName, String hospital, String complain, String status) async {
    final response = await http.post(
      Uri.parse('$baseUrl/registrations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'user_name': userName,
        'hospital': hospital,
        'complain': complain,
        'status': status,
      }),
    );
    _checkResponse(response);
  }

  
  // Fungsi untuk memperbarui status registrasi
Future<void> updateRegistrationStatus(int registrationId, String status) async {
  // Validasi status sebelum dikirim
  if (!["pending", "approved", "rejected"].contains(status)) {
    throw Exception("Invalid status value");
  }

  final response = await http.put(
    Uri.parse('$baseUrl/registrations/$registrationId'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'status': status}), // Kirim status
  );
  _checkResponse(response);
}



  // Fungsi untuk menghapus data registration
  Future<void> deleteRegistration(int registrationId) async {
    final response = await http.delete(Uri.parse('$baseUrl/registrations/$registrationId'));
    _checkResponse(response);
  }
}


