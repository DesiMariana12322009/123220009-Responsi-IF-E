import 'package:flutter/material.dart';
import 'api_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final modelController = TextEditingController();
  final brandController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();
  final websiteController = TextEditingController();
  final ramController = TextEditingController();

  int storage = 128;
  final List<int> storageOptions = [128, 256, 512];

  void submit() async {
    final model = modelController.text.trim();
    final brand = brandController.text.trim();
    final price = int.tryParse(priceController.text.trim()) ?? 0;
    final image = imageController.text.trim();
    final website = websiteController.text.trim();
    final ram = int.tryParse(ramController.text.trim()) ?? 4;

    if (model.isEmpty || brand.isEmpty || price == 0 || image.isEmpty || website.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap lengkapi semua data')),
      );
      return;
    }

    final data = {
      'model': model,
      'brand': brand,
      'price': price,
      'image': image,
      'website': website,
      'storage': storage,
      'ram': ram,
    };

    try {
      await ApiService.createSmartphone(data);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Smartphone')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: modelController,
            decoration: const InputDecoration(labelText: 'Model'),
          ),
          TextField(
            controller: brandController,
            decoration: const InputDecoration(labelText: 'Brand'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Harga (Rp)'),
          ),
          TextField(
            controller: imageController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          TextField(
            controller: websiteController,
            decoration: const InputDecoration(labelText: 'Website URL'),
          ),
          TextField(
            controller: ramController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'RAM (GB)'),
          ),
          DropdownButtonFormField<int>(
            value: storage,
            items: storageOptions
                .map((val) => DropdownMenuItem(value: val, child: Text('$val GB')))
                .toList(),
            onChanged: (val) => setState(() => storage = val!),
            decoration: const InputDecoration(labelText: 'Storage'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
