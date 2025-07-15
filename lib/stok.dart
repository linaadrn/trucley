import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('plot1');
  List<Map<String, dynamic>> stokList = [];

  @override
  void initState() {
    super.initState();
    fetchStokData();
  }

  void fetchStokData() async {
    final snapshot = await _database.get();
    final data = snapshot.value as Map<dynamic, dynamic>;

    List<Map<String, dynamic>> tempList = [];

    data.forEach((tanggal, waktuData) {
      (waktuData as Map<dynamic, dynamic>).forEach((waktu, value) {
        tempList.add({
          'tanggal': tanggal,
          'waktu': waktu,
          'stok': value['stok'],
        });
      });
    });

    // Urutkan berdasarkan tanggal & waktu
    tempList.sort((a, b) {
      final dateA = '${a['tanggal']} ${a['waktu']}';
      final dateB = '${b['tanggal']} ${b['waktu']}';
      return dateB.compareTo(dateA); // descending
    });

    setState(() {
      stokList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stok Pakan'),
        backgroundColor: const Color(0xFF792A2A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: stokList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: stokList.length,
                itemBuilder: (context, index) {
                  final item = stokList[index];
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.inventory_2_rounded,
                          size: 50,
                          color: Color(0xFF792A2A),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Jumlah Stok Pakan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['stok']} kg',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Waktu: ${item['tanggal']} - ${item['waktu']} WIB',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
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
