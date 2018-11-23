import 'package:test/test.dart';
import 'package:mapper/mapper.dart';

@Entity(fullMatch: true)
class Simple {
  List<String> strProp;
  List<int> intProp;
  List<bool> boolProp;
  List<double> doubleProp;
}

const Map<String, dynamic> simple = const {
  "strProp": ["val", "val2"],
  "intProp": [13, 14],
  "boolProp": [true, false],
  "doubleProp": [12.4, 15.6],
};

main() {
  test("Should convert map to object and back", () async {
    Simple obj = decode<Simple>(simple);

    expect(obj.strProp.length, (simple['strProp'] as List).length);
    expect(obj.strProp[0], (simple['strProp'])[0]);
    expect(obj.strProp[1], (simple['strProp'])[1]);

    expect(obj.intProp.length, (simple['intProp'] as List).length);
    expect(obj.intProp[0], simple['intProp'][0]);
    expect(obj.intProp[1], simple['intProp'][1]);

    expect(obj.boolProp.length, (simple['boolProp'] as List).length);
    expect(obj.boolProp[0], simple['boolProp'][0]);
    expect(obj.boolProp[1], simple['boolProp'][1]);

    expect(obj.doubleProp.length, (simple['doubleProp'] as List).length);
    expect(obj.doubleProp[0], simple['doubleProp'][0]);
    expect(obj.doubleProp[1], simple['doubleProp'][1]);

    Map<String, dynamic> simple2 = encode(obj);

    expect(simple2['strProp'], simple['strProp']);
    expect(simple2['intProp'], simple['intProp']);
    expect(simple2['boolProp'], simple['boolProp']);
    expect(simple2['doubleProp'], simple['doubleProp']);
  });
}
