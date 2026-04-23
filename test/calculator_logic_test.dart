import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_glp1_tracker/src/features/calculator/calculator_logic.dart';

void main() {
  test('concentration 5mg in 2ml = 2500 mcg/ml', () {
    expect(CalculatorLogic.concentrationMcgPerMl(vialMg: 5, bacMl: 2), 2500);
  });

  test('250 mcg at 2500 mcg/ml on U-100 = 0.1 ml, 10 units', () {
    final r = CalculatorLogic.draw(
      concentrationMcgPerMl: 2500,
      desiredMcg: 250,
      syringe: SyringeType.u100,
    );
    expect(r.ml, closeTo(0.1, 0.001));
    expect(r.units, 10);
  });

  test('GLP-1: 0.5 mg at 5 mg/ml on U-100 = 10 units', () {
    final r = CalculatorLogic.glp1Draw(concentrationMgPerMl: 5, weeklyDoseMg: 0.5);
    expect(r.units, 10);
  });

  test('zero concentration returns zero', () {
    expect(CalculatorLogic.concentrationMcgPerMl(vialMg: 5, bacMl: 0), 0);
  });
}
