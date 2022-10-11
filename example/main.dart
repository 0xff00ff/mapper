import 'package:mapper/mapper.dart';

class BoolParser extends Parser {
  bool decode(val) {
    if (val is int) {
      return val == 1;
    }
    return null;
  }

  int encode(val) {
    if (val is bool) {
      return val == true ? 1 : 0;
    }
    return null;
  }
}

@Entity(fullMatch: true)
class Simple {
  String strProp;
  int intProp;
  bool boolProp;
  double doubleProp;
}

const Map<String, dynamic> simple = const {
  "strProp": "val",
  "intProp": 13,
  "boolProp": 1,
  "doubleProp": 12.4,
};

main() {
  addParser('bool', new BoolParser());

  Simple obj = decode<Simple>(simple);

  obj.strProp; // val
  obj.intProp; // 13
  obj.boolProp; // true, was 1
  obj.doubleProp; // 12,4

  Map<String, dynamic> simple2 = encode(obj);

  assert(simple2['strProp'] == simple['strProp']); // true
  assert(simple2['intProp'] == simple['intProp']); // true
  assert(simple2['boolProp'] == simple['boolProp']); // true
  assert(simple2['doubleProp'] == simple['doubleProp']); // true
  print("done");
}
