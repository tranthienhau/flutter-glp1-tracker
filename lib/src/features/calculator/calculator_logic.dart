enum SyringeType { u100, u50 }

class DrawResult {
  final double ml;
  final int units;
  const DrawResult(this.ml, this.units);
}

class CalculatorLogic {
  static double concentrationMcgPerMl({required double vialMg, required double bacMl}) {
    if (bacMl <= 0) return 0;
    return (vialMg * 1000) / bacMl;
  }

  static DrawResult draw({
    required double concentrationMcgPerMl,
    required double desiredMcg,
    required SyringeType syringe,
  }) {
    if (concentrationMcgPerMl <= 0) return const DrawResult(0, 0);
    final ml = desiredMcg / concentrationMcgPerMl;
    final scale = syringe == SyringeType.u100 ? 100 : 50;
    final units = (ml * scale).round();
    return DrawResult(ml, units);
  }

  static DrawResult glp1Draw({
    required double concentrationMgPerMl,
    required double weeklyDoseMg,
  }) {
    if (concentrationMgPerMl <= 0) return const DrawResult(0, 0);
    final ml = weeklyDoseMg / concentrationMgPerMl;
    final units = (ml * 100).round();
    return DrawResult(ml, units);
  }
}
