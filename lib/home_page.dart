import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'models/smartphone.dart';
import 'create_page.dart';
import 'edit_page.dart';
import 'detail_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Smartphone>> smartphoneList;

  @override
  void initState() {
    super.initState();
    smartphoneList = ApiService.getSmartphones();
  }

  void refreshList() {
    setState(() {
      smartphoneList = ApiService.getSmartphones();
    });
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void deleteData(int id) async {
    try {
      await ApiService.deleteSmartphone(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
      refreshList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smartphone List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: FutureBuilder<List<Smartphone>>(
        future: smartphoneList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat data'));
          } else if (snapshot.hasData) {
            final list = snapshot.data!;
            if (list.isEmpty) {
              return const Center(child: Text('Tidak ada data smartphone'));
            }
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final phone = list[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: ListTile(
                    leading: Image.network(
                      phone.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                    ),
                    title: Text('${phone.model} - ${phone.brand}'),
                    subtitle: Text('Rp ${phone.price.toStringAsFixed(0)}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailPage(phone: phone)),
                      );
                    },
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPage(smartphone: phone),
                              ),
                            ).then((_) => refreshList());
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteData(phone.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Data tidak ditemukan'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreatePage()),
          ).then((_) => refreshList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
