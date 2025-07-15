import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('plot1');
  List<Map<String, String>> riwayatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  void fetchRiwayat() async {
    final snapshot = await _database.get();

    final data = snapshot.value as Map<dynamic, dynamic>?;

    List<Map<String, String>> tempList = [];

    if (data != null) {
      data.forEach((tanggal, jamData) {
        (jamData as Map<dynamic, dynamic>).forEach((jam, value) {
          final stok = value['stok'];
          if (stok != null) {
            // Format tanggal jadi readable
            final parts = tanggal.toString().split('_');
            if (parts.length == 3) {
              final hari = parts[2];
              final bulan = parts[1];
              final tahun = parts[0];
              final tanggalFormatted = '$hari-${bulan}-${tahun} $jam WIB';

              tempList.add({
                'waktu': tanggalFormatted,
                'stok': stok.toString(),
              });
            }
          }
        });
      });

      // Urutkan descending (data terbaru di atas)
      tempList.sort((a, b) => b['waktu']!.compareTo(a['waktu']!));
    }

    setState(() {
      riwayatList = tempList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pakan'),
        backgroundColor: const Color(0xFF792A2A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : riwayatList.isEmpty
                ? const Center(child: Text('Belum ada riwayat.'))
                : ListView.builder(
                    itemCount: riwayatList.length,
                    itemBuilder: (context, index) {
                      final item = riwayatList[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              size: 50,
                              color: Color(0xFF792A2A),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Waktu Pemberian Pakan',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item['waktu']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stok: ${item['stok']} kg',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 32,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
