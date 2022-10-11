import 'package:test/test.dart';
import 'package:mapper/mapper.dart';

@Entity(fullMatch: true)
class Simple {
  String? strProp;
  int? intProp;
  bool? boolProp;
  double? doubleProp;
}

const Map<String, dynamic> simple = const {
  "strProp": "val",
  "intProp": 13,
  "boolProp": true,
  "doubleProp": 12.4,
};

main() {
  test("Should convert map to object and back", () async {
    Simple obj = decode<Simple>(simple)!;

    expect(obj.strProp, simple['strProp']);
    expect(obj.intProp, simple['intProp']);
    expect(obj.boolProp, simple['boolProp']);
    expect(obj.doubleProp, simple['doubleProp']);

    Map<String, dynamic> simple2 = encode(obj);

    expect(simple2['strProp'], simple['strProp']);
    expect(simple2['intProp'], simple['intProp']);
    expect(simple2['boolProp'], simple['boolProp']);
    expect(simple2['doubleProp'], simple['doubleProp']);
  });
}
