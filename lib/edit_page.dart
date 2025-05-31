import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models/smartphone.dart';

class EditPage extends StatefulWidget {
  final Smartphone smartphone;

  const EditPage({super.key, required this.smartphone});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController modelController;
  late TextEditingController brandController;
  late TextEditingController priceController;
  late TextEditingController imageController;
  late TextEditingController websiteController;

  int ram = 4;
  int storage = 128;

  final List<int> ramOptions = [4, 6, 8, 12];
  final List<int> storageOptions = [64, 128, 256, 512];

  @override
  void initState() {
    super.initState();
    final phone = widget.smartphone;
    modelController = TextEditingController(text: phone.model);
    brandController = TextEditingController(text: phone.brand);
    priceController = TextEditingController(text: phone.price.toString());
    imageController = TextEditingController(text: phone.image);
    websiteController = TextEditingController(text: phone.website);

    ram = phone.ram;
    storage = phone.storage;
  }

  void submit() async {
    final model = modelController.text.trim();
    final brand = brandController.text.trim();
    final price = double.tryParse(priceController.text.trim()) ?? 0;
    final image = imageController.text.trim();
    final website = websiteController.text.trim();

    if (model.isEmpty || brand.isEmpty || image.isEmpty || website.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field wajib diisi')),
      );
      return;
    }

    final data = {
      'model': model,
      'brand': brand,
      'price': price,
      'image': image,
      'website': website,
      'ram': ram,
      'storage': storage,
    };

    try {
      await ApiService.updateSmartphone(widget.smartphone.id, data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memperbarui data')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Smartphone')),
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
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          TextField(
            controller: imageController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          TextField(
            controller: websiteController,
            decoration: const InputDecoration(labelText: 'Website URL'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: ram,
            items: ramOptions
                .map((val) => DropdownMenuItem(value: val, child: Text('$val GB RAM')))
                .toList(),
            onChanged: (val) => setState(() => ram = val!),
            decoration: const InputDecoration(labelText: 'RAM'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            value: storage,
            items: storageOptions
                .map((val) => DropdownMenuItem(value: val, child: Text('$val GB Storage')))
                .toList(),
            onChanged: (val) => setState(() => storage = val!),
            decoration: const InputDecoration(labelText: 'Storage'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
