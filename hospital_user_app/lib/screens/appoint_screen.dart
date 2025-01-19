import 'package:flutter/material.dart';
import 'newappoint_screen.dart';

class AppointmentScreen extends StatefulWidget {
  final String userName; // Menerima parameter userName

  AppointmentScreen({required this.userName});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // List dummy data untuk menampilkan pendaftaran
  List<Map<String, String>> registrations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrations'),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Welcome
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
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
                    "Welcome to the registration system. Here, you can easily register for a hospital visit. "
                    "Just click the button below to start filling out your registration form. Your health matters to us!",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // List of Registrations
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Your Registrations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            registrations.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "You haven't registered for any appointments yet. Click the button below to start your first registration.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: registrations.length,
                    itemBuilder: (context, index) {
                      final registration = registrations[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(
                            registration['user_name']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              '${registration['hospital']} (${registration['status']!})'),
                        ),
                      );
                    },
                  ),
            SizedBox(height: 20),

            // Button for New Registration
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Navigasi ke halaman form pendaftaran
                  final newRegistration = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewAppointmentScreen(
                        userId: 1, // Ganti dengan ID user yang sedang login
                        userName: widget.userName, // Menggunakan userName yang sudah ada
                      ),
                    ),
                  );

                  // Jika ada data baru, tambahkan ke daftar
                  if (newRegistration != null) {
                    setState(() {
                      registrations.add({
                        'user_name': newRegistration['user_name'],
                        'hospital': newRegistration['hospital'],
                        'status': newRegistration['status'],
                      });
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.blueAccent, // Warna latar belakang
                  foregroundColor: Colors.white, // Warna teks
                  elevation: 5,
                ),
                child: Text(
                  'New Registration',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
