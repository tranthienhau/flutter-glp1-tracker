import 'package:flutter/material.dart';
import 'protocol_data.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _query = '';
  String _category = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = protocols.where((p) {
      final matchesCat = _category == 'All' || p.category == _category;
      final matchesQuery = _query.isEmpty ||
          p.name.toLowerCase().contains(_query.toLowerCase());
      return matchesCat && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Protocol Library')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: categories.map((c) {
                final selected = c == _category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c),
                    selected: selected,
                    onSelected: (_) => setState(() => _category = c),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, i) => _ProtocolTile(p: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProtocolTile extends StatelessWidget {
  final Protocol p;
  const _ProtocolTile({required this.p});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('${p.dose} - ${p.frequency}'),
        trailing: Chip(label: Text(p.category)),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => _ProtocolDetail(p: p),
        )),
      ),
    );
  }
}

class _ProtocolDetail extends StatelessWidget {
  final Protocol p;
  const _ProtocolDetail({required this.p});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(p.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _row('Category', p.category),
          _row('Research dose', p.dose),
          _row('Frequency', p.frequency),
          _row('Route', p.route),
          _row('Cycle', p.cycle),
          _row('Storage', p.storage),
          if (p.titration != null) ...[
            const SizedBox(height: 12),
            const Text('Titration', style: TextStyle(fontWeight: FontWeight.w700)),
            ...p.titration!.map((t) => ListTile(
                  dense: true,
                  title: Text(t),
                )),
          ],
          const SizedBox(height: 16),
          Text(p.notes),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 120, child: Text(k, style: const TextStyle(color: Colors.white60))),
            Expanded(child: Text(v)),
          ],
        ),
      );
}
