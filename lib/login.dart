import 'package:flutter/material.dart';
import 'dashboard.dart'; // pastikan file dashboarddd.dart sudah dibuat

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF792A2A), // warna maroon seperti gambar
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo gambar
            Image.asset(
              'assets/images/logo1.png',
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 16),
            // Teks TRUCLEY
            const Text(
              'TRUCLEY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Masuk
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboarddd()),
                );
              },
              child: const Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
