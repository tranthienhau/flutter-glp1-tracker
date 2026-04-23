import 'package:flutter/material.dart';

enum Medication { semaglutide, tirzepatide }

class TitrationPhase {
  final int weekStart;
  final int weekEnd;
  final double doseMg;
  const TitrationPhase(this.weekStart, this.weekEnd, this.doseMg);
}

const _semaglutide = [
  TitrationPhase(1, 4, 0.25),
  TitrationPhase(5, 8, 0.5),
  TitrationPhase(9, 12, 1.0),
  TitrationPhase(13, 16, 1.7),
  TitrationPhase(17, 52, 2.4),
];

const _tirzepatide = [
  TitrationPhase(1, 4, 2.5),
  TitrationPhase(5, 8, 5.0),
  TitrationPhase(9, 12, 7.5),
  TitrationPhase(13, 16, 10.0),
  TitrationPhase(17, 52, 15.0),
];

class TitrationScreen extends StatefulWidget {
  const TitrationScreen({super.key});

  @override
  State<TitrationScreen> createState() => _TitrationScreenState();
}

class _TitrationScreenState extends State<TitrationScreen> {
  Medication _med = Medication.semaglutide;
  DateTime _start = DateTime.now().subtract(const Duration(days: 35));

  List<TitrationPhase> get _plan =>
      _med == Medication.semaglutide ? _semaglutide : _tirzepatide;

  int get _currentWeek => DateTime.now().difference(_start).inDays ~/ 7 + 1;

  TitrationPhase? get _currentPhase {
    for (final p in _plan) {
      if (_currentWeek >= p.weekStart && _currentWeek <= p.weekEnd) return p;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final phase = _currentPhase;
    return Scaffold(
      appBar: AppBar(title: const Text('Titration')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<Medication>(
            segments: const [
              ButtonSegment(value: Medication.semaglutide, label: Text('Semaglutide')),
              ButtonSegment(value: Medication.tirzepatide, label: Text('Tirzepatide')),
            ],
            selected: {_med},
            onSelectionChanged: (s) => setState(() => _med = s.first),
          ),
          const SizedBox(height: 16),
          if (phase != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current phase', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text('${phase.doseMg} mg weekly',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF14B8A6))),
                    const SizedBox(height: 8),
                    Text('Week $_currentWeek of ${phase.weekEnd}'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          const Text('Roadmap', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ..._plan.map((p) => _PhaseTile(p: p, currentWeek: _currentWeek)),
        ],
      ),
    );
  }
}

class _PhaseTile extends StatelessWidget {
  final TitrationPhase p;
  final int currentWeek;
  const _PhaseTile({required this.p, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    final isCurrent = currentWeek >= p.weekStart && currentWeek <= p.weekEnd;
    final isDone = currentWeek > p.weekEnd;
    final color = isCurrent
        ? const Color(0xFF14B8A6)
        : isDone
            ? Colors.white38
            : Colors.white60;
    final icon = isDone
        ? Icons.check_circle
        : isCurrent
            ? Icons.radio_button_checked
            : Icons.radio_button_off;
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text('Weeks ${p.weekStart}-${p.weekEnd}'),
        subtitle: Text('${p.doseMg} mg'),
        trailing: isCurrent ? const Text('Current') : null,
      ),
    );
  }
}
