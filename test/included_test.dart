import 'package:test/test.dart';
import 'package:mapper/mapper.dart';

class Simple {
  String strProp;
  int intProp;
  Simple2 subclass;
}

class Simple2 {
  String strProp2;
  int intProp2;
  Simple3 subclass2;
}

class Simple3 {
  String strProp3;
  int intProp3;
}

const Map<String, dynamic> simple = const {
  "strProp": "strProp",
  // skip int
  "subclass": <String, dynamic> {
    "strProp2": 3, // should skip
    "intProp2": 3.14, // should skip
    "subclass2": <String, dynamic> {
      "strProp3": "strProp3",
      "intProp3": 12,
    }
  }
};

main() {
  test("Should convert map to object and back", () async {

    Simple obj = decode<Simple>(simple);

    expect(obj.strProp, 'strProp');
    expect(obj.subclass is Simple2, true);
    expect(obj.subclass.strProp2, null);
    expect(obj.subclass.intProp2, null);
    expect(obj.subclass.subclass2 is Simple3, true);
    expect(obj.subclass.subclass2.strProp3, 'strProp3');
    expect(obj.subclass.subclass2.intProp3, 12);

    Map<String, dynamic> simple2 = encode(obj);

    expect(simple2['strProp'], 'strProp');
    expect(simple2['subclass'] is Map, true);
    expect(simple2['subclass']['strProp2'], null);
    expect(simple2['subclass']['intProp2'], null);
    expect(simple2['subclass']['subclass2'] is Map, true);
    expect(simple2['subclass']['subclass2']['strProp3'], 'strProp3');
    expect(simple2['subclass']['subclass2']['intProp3'], 12);

  });
}