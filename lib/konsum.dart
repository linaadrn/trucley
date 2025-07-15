import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class KonsumsiPage extends StatefulWidget {
  const KonsumsiPage({super.key});

  @override
  State<KonsumsiPage> createState() => _KonsumsiPageState();
}

class _KonsumsiPageState extends State<KonsumsiPage> {
  String selectedBulan = 'Juli';
  String selectedTahun = '2025';

  final List<String> bulanList = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  final List<String> tahunList = ['2023', '2024', '2025'];

  List<Map<String, dynamic>> dataKonsumsi = [];
  bool isLoading = false;

  int get totalKonsumsi {
    return dataKonsumsi.fold(0, (sum, item) => sum + (item['jumlah'] as int));
  }

  @override
  void initState() {
    super.initState();
    fetchDataKonsumsi();
  }

  void fetchDataKonsumsi() async {
  setState(() {
    isLoading = true;
  });

  try {
    final ref = FirebaseDatabase.instance.ref('plot1');
    final snapshot = await ref.get();

    final rawData = snapshot.value as Map<dynamic, dynamic>?;

    if (rawData == null) {
      setState(() {
        dataKonsumsi = [];
        isLoading = false;
      });
      return;
    }

    final int bulanIndex = bulanList.indexOf(selectedBulan) + 1;
    final String bulanStr = bulanIndex.toString().padLeft(2, '0');
    final String prefix = '${selectedTahun}_$bulanStr';

    Map<String, int> konsumsiPerHari = {};

    rawData.forEach((tanggal, jamData) {
      if (tanggal.toString().startsWith(prefix)) {
        // Ambil hari dari format 2025_07_15
        List<String> parts = tanggal.toString().split('_');
        if (parts.length != 3) return;
        final hari = parts[2];
        if (int.tryParse(hari) == null) return;

        final jamStokList = (jamData as Map<dynamic, dynamic>).entries
    .where((e) => e.value['stok'] != null)
    .map((e) => MapEntry(e.key.toString(), e.value['stok'] as int))
    .toList();

        if (jamStokList.length >= 2) {
          jamStokList.sort((a, b) => a.key.compareTo(b.key)); // urutkan berdasarkan jam

          final stokAwal = jamStokList.first.value;
          final stokAkhir = jamStokList.last.value;

          konsumsiPerHari[hari] = stokAwal - stokAkhir; // hasil positif
        } else {
          konsumsiPerHari[hari] = 0;
        }
      }
    });

    final List<Map<String, dynamic>> tempData = konsumsiPerHari.entries.map((e) {
      return {
        'tanggal': e.key.toString(),
        'jumlah': e.value,
      };
    }).toList()
      ..sort((a, b) {
        final tglA = int.tryParse(a['tanggal'].toString()) ?? 0;
        final tglB = int.tryParse(b['tanggal'].toString()) ?? 0;
        return tglA.compareTo(tglB);
      });

    setState(() {
      dataKonsumsi = tempData;
      isLoading = false;
    });
  } catch (e) {
    print('❌ Gagal mengambil data: $e');
    setState(() {
      isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Konsumsi Bulanan'),
        backgroundColor: const Color(0xFF792A2A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown Bulan & Tahun
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedBulan,
                    decoration: const InputDecoration(labelText: 'Pilih Bulan'),
                    items: bulanList.map((String bulan) {
                      return DropdownMenuItem(
                        value: bulan,
                        child: Text(bulan),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBulan = value!;
                      });
                      fetchDataKonsumsi();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedTahun,
                    decoration: const InputDecoration(labelText: 'Pilih Tahun'),
                    items: tahunList.map((String tahun) {
                      return DropdownMenuItem(
                        value: tahun,
                        child: Text(tahun),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedTahun = value!;
                      });
                      fetchDataKonsumsi();
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Total Konsumsi Bulan Ini
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total Konsumsi Bulan $selectedBulan $selectedTahun: $totalKonsumsi kg',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tabel Data Konsumsi
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : dataKonsumsi.isEmpty
                      ? const Center(child: Text('Tidak ada data konsumsi.'))
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => const Color(0xFF792A2A)),
                            headingTextStyle:
                                const TextStyle(color: Colors.white),
                            columns: const [
                              DataColumn(label: Text('No')),
                              DataColumn(label: Text('Tanggal')),
                              DataColumn(label: Text('Konsumsi (kg)')),
                            ],
                            rows: dataKonsumsi.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              var item = entry.value;
                              return DataRow(cells: [
                                DataCell(Text(index.toString())),
                                DataCell(Text(
                                    '${item['tanggal']} $selectedBulan $selectedTahun')),
                                DataCell(Text('${item['jumlah']}')),
                              ]);
                            }).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
