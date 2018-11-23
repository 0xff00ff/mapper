import 'package:mapper/mapper.dart';
import 'package:test/test.dart';

@Entity(fullMatch: true)
class Simple {
  @Property(name: 'str') // change field name
  String strProp;
  bool boolProp;
  @Property(ignore: true) // ignore this field
  int intProp;
}

main() {

  test("Should convert map to object and back", () async {

    Simple obj = new Simple();
    obj.strProp = "string";
    obj.boolProp = true;
    obj.intProp = 3;

    Map<String, dynamic> simple = encode(obj);

    expect(simple['str'], 'string');
    expect(simple.containsKey('strProp'), false); // key name was changed
    expect(simple['boolProp'], true);
    expect(simple.containsKey('intProp'), false); // field was ignored

    Simple obj2 = decode(simple);

    expect(obj2.strProp, 'string');
    expect(obj2.boolProp, true);
    expect(obj2.intProp, null);
  });
}