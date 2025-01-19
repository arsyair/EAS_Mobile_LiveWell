import 'dart:async';
import 'package:flutter/material.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardScreen()));
    });

    return Scaffold(
      body: Stack(
        children: [
          // Background Gambar
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/profile.jpg', // Pastikan gambar ada di folder assets/images dan terdaftar di pubspec.yaml
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay Transparan
          Container(
            color: Colors.black.withOpacity(0.6), // Warna overlay transparan
          ),
          // Konten di tengah
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo_user.png', // Pastikan file logo ada di folder assets/images dan terdaftar di pubspec.yaml
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                // Text aplikasi
                Text(
                  "For Admin",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
