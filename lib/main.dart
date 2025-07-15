import 'package:flutter/material.dart';
import 'login.dart'; // pastikan file login.dart sudah ada di folder yang sama atau atur sesuai path
import 'firebase_options.dart'; // Ganti dengan file Firebase Options Anda
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Gunakan konfigurasi Firebase yang sesuai platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trucley App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(), // diarahkan ke halaman login
    );
  }
}