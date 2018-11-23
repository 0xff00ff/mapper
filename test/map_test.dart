import 'package:test/test.dart';
import 'package:mapper/mapper.dart';

@Entity(fullMatch: true)
class Simple {
  Map<String, String> strProp;
  Map<String, int> intProp;
  Map<String, bool> boolProp;
  Map<String, double> doubleProp;
}

const Map<String, dynamic> simple = const {
  "strProp": <String, String>{"str": "val"},
  "intProp": <String, int>{"int": 14},
  "boolProp": <String, bool>{"bool": false},
  "doubleProp": <String, double>{"double": 15.6},
};

main() {
  test("Should convert map to object and back", () async {
    Simple obj = decode<Simple>(simple);

    expect(obj.strProp['str'], simple['strProp']['str']);
    expect(obj.intProp['int'], simple['intProp']['int']);
    expect(obj.boolProp['bool'], simple['boolProp']['bool']);
    expect(obj.doubleProp['double'], simple['doubleProp']['double']);

    Map<String, dynamic> simple2 = encode(obj);

    expect(simple2['strProp'], simple['strProp']);
    expect(simple2['intProp'], simple['intProp']);
    expect(simple2['boolProp'], simple['boolProp']);
    expect(simple2['doubleProp'], simple['doubleProp']);
  });
}
