import 'package:flutter/material.dart';

class DoseEntry {
  final DateTime at;
  final String compound;
  final String dose;
  final String? notes;
  final bool completed;
  const DoseEntry({
    required this.at,
    required this.compound,
    required this.dose,
    this.notes,
    this.completed = false,
  });

  DoseEntry toggle() =>
      DoseEntry(at: at, compound: compound, dose: dose, notes: notes, completed: !completed);
}

class DoseLogScreen extends StatefulWidget {
  const DoseLogScreen({super.key});

  @override
  State<DoseLogScreen> createState() => _DoseLogScreenState();
}

class _DoseLogScreenState extends State<DoseLogScreen> {
  int _tab = 0;

  final List<DoseEntry> _entries = [
    DoseEntry(at: DateTime.now(), compound: 'BPC-157', dose: '250 mcg SubQ'),
    DoseEntry(
        at: DateTime.now().add(const Duration(hours: 8)),
        compound: 'Ipamorelin',
        dose: '200 mcg SubQ'),
    DoseEntry(
        at: DateTime.now().subtract(const Duration(days: 1)),
        compound: 'Semaglutide',
        dose: '0.5 mg weekly',
        completed: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dose Log')),
      body: Column(
        children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Today')),
              ButtonSegment(value: 1, label: Text('History')),
              ButtonSegment(value: 2, label: Text('Vials')),
            ],
            selected: {_tab},
            onSelectionChanged: (s) => setState(() => _tab = s.first),
          ),
          const SizedBox(height: 12),
          Expanded(child: _bodyFor(_tab)),
        ],
      ),
    );
  }

  Widget _bodyFor(int tab) {
    final today = DateTime.now();
    switch (tab) {
      case 0:
        final list = _entries
            .where((e) =>
                e.at.year == today.year &&
                e.at.month == today.month &&
                e.at.day == today.day)
            .toList();
        return ListView(
          padding: const EdgeInsets.all(12),
          children: list.asMap().entries.map((kv) {
            final i = _entries.indexOf(kv.value);
            return Card(
              child: CheckboxListTile(
                value: kv.value.completed,
                onChanged: (_) => setState(() => _entries[i] = _entries[i].toggle()),
                title: Text(
                  '${kv.value.compound} - ${kv.value.dose}',
                  style: TextStyle(
                    decoration: kv.value.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                subtitle: Text('${kv.value.at.hour.toString().padLeft(2, '0')}:${kv.value.at.minute.toString().padLeft(2, '0')}'),
              ),
            );
          }).toList(),
        );
      case 1:
        return ListView(
          padding: const EdgeInsets.all(12),
          children: _entries
              .map((e) => Card(
                    child: ListTile(
                      title: Text('${e.compound} - ${e.dose}'),
                      subtitle: Text('${e.at.month}/${e.at.day}'),
                      trailing: e.completed
                          ? const Icon(Icons.check_circle, color: Color(0xFF14B8A6))
                          : null,
                    ),
                  ))
              .toList(),
        );
      default:
        return ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            _VialCard(compound: 'BPC-157', dosesLeft: 14, total: 20, location: 'Fridge'),
            _VialCard(compound: 'Ipamorelin', dosesLeft: 3, total: 30, location: 'Fridge'),
            _VialCard(compound: 'Semaglutide', dosesLeft: 8, total: 12, location: 'Fridge'),
          ],
        );
    }
  }
}

class _VialCard extends StatelessWidget {
  final String compound;
  final int dosesLeft;
  final int total;
  final String location;
  const _VialCard({
    required this.compound,
    required this.dosesLeft,
    required this.total,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final pct = dosesLeft / total;
    final lowStock = dosesLeft <= 5;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(compound, style: const TextStyle(fontWeight: FontWeight.w700)),
                if (lowStock)
                  const Chip(label: Text('Low'), backgroundColor: Color(0xFF7F1D1D)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: pct, minHeight: 8),
            const SizedBox(height: 8),
            Text('$dosesLeft of $total doses - $location'),
          ],
        ),
      ),
    );
  }
}
