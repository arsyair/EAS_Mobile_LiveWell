import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.1.10:3000'; // Ganti dengan IP backend Anda

  // Fetch users from the API
  Future<List> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching users: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load users');
    }
  }

  // Register a new user
  Future<void> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('User registered successfully: ${response.body}');
      } else {  
        final responseBody = jsonDecode(response.body);
        print('Error registering user: ${responseBody['error']}');
        throw Exception(responseBody['error'] ?? 'Failed to register user');
      }
    } catch (e) {
      print('Registration failed: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // Login a user (manual validation)
  Future<Map<String, dynamic>> login(String email, String password) async {
    final users = await getUsers();

    final user = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => null,
    );

    if (user != null) {
      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Fetch user profile by ID
  Future<Map<String, dynamic>> getUserProfile(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching user profile: ${response.statusCode}');
      throw Exception('Failed to load profile');
    }
  }

  // Fetch doctors from the API
  Future<List> getDoctors() async {
    final url = Uri.parse('$baseUrl/doctors');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching doctors: ${response.statusCode}');
      throw Exception('Failed to load doctors');
    }
  }

  // Create a new registration
  static Future<bool> submitRegistration(Map<String, dynamic> registrationData) async {
    final url = Uri.parse('http://192.168.1.15:3000/registrations');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registrationData),
      );

      if (response.statusCode == 201) {
        print('Registration submitted successfully: ${response.body}');
        return true; // Pendaftaran berhasil
      } else {
        print('Failed to submit registration: ${response.body}');
        return false; // Pendaftaran gagal
      }
    } catch (e) {
      print('Error during registration submission: $e');
      return false; // Kesalahan terjadi
    }
  }

  // Delete a registration
  Future<void> deleteRegistration(int registrationId) async {
    final url = Uri.parse('$baseUrl/registrations/$registrationId');

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Registration deleted successfully');
      } else {
        final responseBody = jsonDecode(response.body);
        print('Error deleting registration: ${responseBody['error']}');
        throw Exception(responseBody['error'] ?? 'Failed to delete registration');
      }
    } catch (e) {
      print('Deletion failed: $e');
      throw Exception('Deletion failed: $e');
    }
  }

  // Update registration status
  Future<void> updateRegistrationStatus({
    required int registrationId,
    required String status,
  }) async {
    final url = Uri.parse('$baseUrl/registrations/$registrationId');

    final body = json.encode({'status': status});

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        print('Registration status updated successfully: ${response.body}');
      } else {
        final responseBody = jsonDecode(response.body);
        print('Error updating registration status: ${responseBody['error']}');
        throw Exception(responseBody['error'] ?? 'Failed to update status');
      }
    } catch (e) {
      print('Update status failed: $e');
      throw Exception('Update status failed: $e');
    }
  }

    Future<void> createRegistrations({
    required int userId,
    required String userName,
    required String hospital,
    required String complain, // Tambahkan complain
  }) async {
    final url = Uri.parse('$baseUrl/registrations');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_id': userId, // Perbaiki penamaan agar sesuai dengan backend
          'user_name': userName,
          'hospital': hospital,
          'complain': complain, // Tambahkan complain
          'status': 'pending', // Default status
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create registration');
      }
    } catch (e) {
      throw Exception('Error creating registration: $e');
    }
  }


  Future<List<dynamic>> getHospitals() async {
    final url = Uri.parse('$baseUrl/hospitals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print('Error fetching hospitals: ${response.statusCode}, ${response.body}');
      throw Exception('Failed to load hospitals');
    }
  }
}

