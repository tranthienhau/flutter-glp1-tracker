import 'package:flutter/material.dart';
import 'calculator_logic.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PepDose'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Reconstitute'),
            Tab(text: 'Dose'),
            Tab(text: 'GLP-1'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          _ReconstituteTab(),
          _DoseTab(),
          _Glp1Tab(),
        ],
      ),
    );
  }
}

class _ReconstituteTab extends StatefulWidget {
  const _ReconstituteTab();
  @override
  State<_ReconstituteTab> createState() => _ReconstituteTabState();
}

class _ReconstituteTabState extends State<_ReconstituteTab> {
  final _vial = TextEditingController(text: '5');
  final _bac = TextEditingController(text: '2');

  double get _concentration {
    final mg = double.tryParse(_vial.text) ?? 0;
    final ml = double.tryParse(_bac.text) ?? 0;
    return CalculatorLogic.concentrationMcgPerMl(vialMg: mg, bacMl: ml);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Field(controller: _vial, label: 'Vial size (mg)', onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        _Field(controller: _bac, label: 'BAC water (ml)', onChanged: (_) => setState(() {})),
        const SizedBox(height: 20),
        _ResultCard(
          title: 'Concentration',
          value: '${_concentration.toStringAsFixed(0)} mcg/ml',
        ),
        const SizedBox(height: 16),
        const _ReconGuide(),
      ],
    );
  }
}

class _DoseTab extends StatefulWidget {
  const _DoseTab();
  @override
  State<_DoseTab> createState() => _DoseTabState();
}

class _DoseTabState extends State<_DoseTab> {
  final _conc = TextEditingController(text: '2500');
  final _dose = TextEditingController(text: '250');
  SyringeType _syringe = SyringeType.u100;

  @override
  Widget build(BuildContext context) {
    final conc = double.tryParse(_conc.text) ?? 0;
    final dose = double.tryParse(_dose.text) ?? 0;
    final result = CalculatorLogic.draw(
      concentrationMcgPerMl: conc,
      desiredMcg: dose,
      syringe: _syringe,
    );
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Field(controller: _conc, label: 'Concentration (mcg/ml)', onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        _Field(controller: _dose, label: 'Desired dose (mcg)', onChanged: (_) => setState(() {})),
        const SizedBox(height: 12),
        SegmentedButton<SyringeType>(
          segments: const [
            ButtonSegment(value: SyringeType.u100, label: Text('U-100')),
            ButtonSegment(value: SyringeType.u50, label: Text('U-50')),
          ],
          selected: {_syringe},
          onSelectionChanged: (s) => setState(() => _syringe = s.first),
        ),
        const SizedBox(height: 20),
        _ResultCard(title: 'Draw', value: '${result.ml.toStringAsFixed(2)} ml'),
        const SizedBox(height: 12),
        _ResultCard(title: 'Syringe units', value: '${result.units}'),
      ],
    );
  }
}

class _Glp1Tab extends StatefulWidget {
  const _Glp1Tab();
  @override
  State<_Glp1Tab> createState() => _Glp1TabState();
}

class _Glp1TabState extends State<_Glp1Tab> {
  double _conc = 5;
  double _weeklyMg = 0.5;

  @override
  Widget build(BuildContext context) {
    final result = CalculatorLogic.glp1Draw(concentrationMgPerMl: _conc, weeklyDoseMg: _weeklyMg);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Vial concentration (mg/ml)'),
        Wrap(
          spacing: 8,
          children: [2.5, 5, 10]
              .map((v) => ChoiceChip(
                    label: Text('$v'),
                    selected: _conc == v,
                    onSelected: (_) => setState(() => _conc = v.toDouble()),
                  ))
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text('Weekly dose (mg)'),
        Wrap(
          spacing: 8,
          children: [0.25, 0.5, 1.0, 1.7, 2.0, 2.4]
              .map((v) => ChoiceChip(
                    label: Text('$v'),
                    selected: _weeklyMg == v,
                    onSelected: (_) => setState(() => _weeklyMg = v),
                  ))
              .toList(),
        ),
        const SizedBox(height: 20),
        _ResultCard(title: 'Units on U-100', value: '${result.units}'),
        const SizedBox(height: 12),
        _ResultCard(title: 'ml equivalent', value: '${result.ml.toStringAsFixed(2)} ml'),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Draw to the ${result.units} unit mark on your insulin syringe.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onChanged;
  const _Field({required this.controller, required this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(labelText: label),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final String value;
  const _ResultCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF14B8A6)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReconGuide extends StatelessWidget {
  const _ReconGuide();

  static const _steps = [
    'Let BAC water warm to room temperature.',
    'Swab vial stopper with alcohol.',
    'Slowly add BAC water down vial wall.',
    'Swirl gently - do not shake.',
    'Refrigerate once reconstituted.',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('5-step reconstitution',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            for (int i = 0; i < _steps.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: const Color(0xFF14B8A6),
                      child: Text('${i + 1}',
                          style: const TextStyle(fontSize: 12, color: Colors.black)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(_steps[i])),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
