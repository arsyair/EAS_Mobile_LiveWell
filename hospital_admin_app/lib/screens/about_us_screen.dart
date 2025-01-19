import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Color(0xFF001F54), // Navy Blue
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo atau gambar
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  'assets/images/logo_admin.png', // Pastikan gambar ini ada di pubspec.yaml
                ),
                backgroundColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 20),

            // Judul aplikasi
            Center(
              child: Text(
                'LiveWell',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001F54),
                ),
              ),
            ),
            SizedBox(height: 5),

            // Slogan
            Center(
              child: Text(
                'Simplifying Healthcare, Connecting Lives',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Tentang Aplikasi
            _buildSectionHeader('About LiveWell'),
            SizedBox(height: 10),
            Text(
              'LiveWell is a modern hospital management application designed to simplify healthcare services. '
              'Our goal is to create a seamless connection between patients and healthcare providers, ensuring better accessibility and efficiency in medical care.',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            // Tujuan
            _buildSectionHeader('Our Goals'),
            SizedBox(height: 10),
            _buildList([
              'Easy access to doctors for consultations.',
              'Efficient appointment scheduling.',
              'Comprehensive medical records management.',
              'Real-time updates on appointments and notifications.',
            ]),
            SizedBox(height: 20),

            // Fungsi
            _buildSectionHeader('Features'),
            SizedBox(height: 10),
            _buildList([
              'Online doctor appointments.',
              'Detailed doctor profiles and specialties.',
              'User-friendly dashboard for patients.',
              'Notifications and reminders for appointments.',
            ]),
            SizedBox(height: 20),

            // Developer Information
            _buildSectionHeader('Developed By'),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: Color(0xFF001F54)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '152022027 Zahra Hisyam A\n152022266 Arsya Ilham R',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Versi
            _buildSectionHeader('App Version'),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF001F54)),
                SizedBox(width: 10),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk header bagian
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF001F54),
      ),
    );
  }

  // Fungsi untuk membuat daftar dengan ikon
  Widget _buildList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF001F54), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
