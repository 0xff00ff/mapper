import 'package:test/test.dart';
import 'package:mapper/mapper.dart';

class BoolParser extends Parser {
  bool? decode(val) {
    if (val is int) {
      return val == 1;
    }
    return null;
  }

  int? encode(val) {
    if (val is bool) {
      return val == true ? 1 : 0;
    }
    return null;
  }
}

@Entity(fullMatch: true)
class Simple {
  String? strProp;
  bool? boolProp;
}

main() {
  test("Should convert map to object and back", () async {
    addParser('bool', new BoolParser());

    Simple obj = new Simple();
    obj.strProp = "string";
    obj.boolProp = true;

    Map<String, dynamic> simple = encode(obj);

    expect(simple['strProp'], 'string');
    expect(simple['boolProp'], 1);
  });
}
