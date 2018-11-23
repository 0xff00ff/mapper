Mapper

Simple library to convert maps to objects and objects to maps

```dart
import 'package:mapper/mapper.dart';

@Entity(fullMatch: true) // will map all fields
class Simple {
  String strProp;
  int intProp;
  bool boolProp;
  double doubleProp;
}

const Map<String, dynamic> simple = const {
  "strProp": "val",
  "intProp": 13,
  "boolProp": true,
  "doubleProp": 12.4,
};

main() {
    Simple obj = decode<Simple>(simple);

    obj.strProp; // val
    obj.intProp; // 13
    obj.boolProp; // true
    obj.doubleProp; 12,4

    Map<String, dynamic> simple2 = encode(obj);

    simple2['strProp'] == simple['strProp']; // true
    simple2['intProp'] == simple['intProp']; // true 
    simple2['boolProp'] == simple['boolProp']; // true
    simple2['doubleProp'] == simple['doubleProp']; // true
}
```



Basic features:
* can convert simple types (String, int, boolean, double)
* can convert Lists and Maps (only with simple types inside)
* can be added external converters
* mirror fields are cache after first use to increase speed
* add meta to control convertation process

Roadmap:
* add ability to convert complex Maps and Lists with included classes
* add ability to convert classes with constructors with arguments

Custom converter example:
```dart
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
  @Property(name: 'str') // change field name
  String strProp;
  bool boolProp;
  @Property(ignore: true) // ignore this field
  int intProp;
}

main() {

    addParser('bool', new BoolParser());

    Simple obj = new Simple();
    obj.strProp = "string";
    obj.boolProp = true;
    obj.intProp = 3;

    Map<String, dynamic> simple = encode(obj);

    simple['str'] == 'string'; // true
    simple.containsKey('strProp'); // false, key name was changed
    simple['boolProp'] == 1; // true
    simple.containsKey('intProp'); // false, field was ignored
}
```