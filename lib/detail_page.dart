import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/smartphone.dart';

class DetailPage extends StatelessWidget {
  final Smartphone phone;

  const DetailPage({super.key, required this.phone});

  void _launchWebsite(BuildContext context) async {
    final url = Uri.parse(phone.website);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka website')),
      );
    }
  }

  final Color pastelPink = const Color(0xFFFFC1CC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pastelPink.withOpacity(0.3),
      appBar: AppBar(
        title: const Text('Detail Smartphone'),
        backgroundColor: pastelPink,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Image.network(
                  phone.image,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              phone.model,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              phone.brand,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Harga: Rp ${phone.price}',
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'RAM: ${phone.ram} GB',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              'Storage: ${phone.storage} GB',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pastelPink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () => _launchWebsite(context),
                  icon: const Icon(Icons.open_in_browser, color: Colors.white),
                  label: const Text(
                    'Kunjungi Website',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
