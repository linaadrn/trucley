import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
        backgroundColor: const Color(0xFF792A2A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Logo aplikasi di tengah
              Center(
                child: Image.asset(
                  'assets/images/logo1.png',
                  width: 120,
                  height: 120,
                ),
              ),

              const SizedBox(height: 30),

              // Deskripsi aplikasi
              const Text(
                'Aplikasi ini digunakan untuk membantu peternak ikan dalam memantau dan mengelola pemberian pakan secara otomatis. '
                'Dengan sistem yang terintegrasi, aplikasi ini dapat mencatat stok pakan, riwayat pemberian pakan, dan konsumsi pakan setiap bulan secara efisien.\n\n'
                'Fitur-fitur yang tersedia di dalam aplikasi ini dirancang untuk meningkatkan produktivitas dan mengurangi kesalahan manual dalam proses budidaya ikan.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 40),

              const Divider(thickness: 1.2),

              const SizedBox(height: 20),

              // Profil pembuat
              Row(
                children: [
                  // Foto mahasiswa
                  ClipOval(
                    child: Image.asset(
                      'assets/images/profil.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Info diri
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Nama : Lina',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'NIM   : 1234567890',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Prodi : S1 Teknik Informatika',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Center(
                child: Text(
                  'Aplikasi ini dibuat oleh Lina sebagai bagian dari Tugas Akhir.\nTerima kasih telah menggunakan aplikasi ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
