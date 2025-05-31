import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/smartphone.dart';

// ✅ BASE URL API kamu
const baseUrl = 'https://tpm-api-responsi-e-f-872136705893.us-central1.run.app/api/v1/phones';

class ApiService {
  // GET: Ambil semua smartphone
  static Future<List<Smartphone>> getSmartphones() async {
    final response = await http.get(Uri.parse(baseUrl));

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> body = json.decode(response.body);
        if (body['data'] == null || body['data'] is! List) {
          throw Exception('Data tidak valid atau kosong');
        }

        final List jsonData = body['data'];
        return jsonData.map((e) => Smartphone.fromJson(e)).toList();
      } catch (e) {
        print('Error parsing JSON: $e');
        throw Exception('Format JSON tidak valid: $e');
      }
    } else {
      throw Exception('Gagal memuat data smartphone: ${response.statusCode}');
    }
  }

  // POST: Tambah smartphone baru
  static Future<void> createSmartphone(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      print('Gagal menambahkan smartphone: ${response.body}');
      throw Exception('Gagal menambahkan smartphone');
    }
  }

  // PUT: Update smartphone
  static Future<void> updateSmartphone(int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      print('Gagal update smartphone: ${response.body}');
      throw Exception('Gagal update smartphone');
    }
  }

  // DELETE: Hapus smartphone
  static Future<void> deleteSmartphone(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      print('Gagal menghapus smartphone: ${response.body}');
      throw Exception('Gagal menghapus smartphone');
    }
  }
}
