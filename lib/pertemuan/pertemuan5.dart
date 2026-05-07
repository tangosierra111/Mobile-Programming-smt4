import 'package:flutter/material.dart';

class Pertemuan5Page extends StatelessWidget {
  const Pertemuan5Page({super.key});

  static const List<_ListViewTopic> _topics = [
    _ListViewTopic(
      title: 'ListView Default',
      description: 'Cocok untuk data statis dengan jumlah item sedikit.',
      icon: Icons.format_list_bulleted,
    ),
    _ListViewTopic(
      title: 'ListView.builder',
      description: 'Digunakan untuk data banyak atau dinamis.',
      icon: Icons.auto_awesome_motion,
    ),
    _ListViewTopic(
      title: 'ListView.separated',
      description: 'Menambahkan pemisah yang rapi di antara item.',
      icon: Icons.segment,
    ),
    _ListViewTopic(
      title: 'ListView horizontal',
      description: 'Menampilkan item yang dapat digeser ke samping.',
      icon: Icons.swap_horiz,
    ),
  ];

  static const List<String> _contacts = [
    'Ayu Pratama',
    'Bima Saputra',
    'Citra Lestari',
    'Dinda Amalia',
    'Eko Maulana',
  ];

  static const List<String> _categories = [
    'Kontak',
    'Produk',
    'Database',
    'API',
    'Galeri',
    'Berita',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pertemuan 5 - ListView'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Materi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Pertemuan 5 membahas penggunaan ListView pada Flutter, '
                    'mulai dari list statis, builder, separated, hingga horizontal list.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Jenis ListView',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _topics.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final topic = _topics[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Icon(topic.icon),
                  ),
                  title: Text(topic.title),
                  subtitle: Text(topic.description),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Contoh ListView Horizontal',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    color: Colors.indigo.shade50,
                    child: Center(
                      child: Text(
                        _categories[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Contoh ListView.separated',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _contacts.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      _contacts[index][0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(_contacts[index]),
                  subtitle: const Text('Contoh data list kontak'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ListViewTopic {
  const _ListViewTopic({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}
