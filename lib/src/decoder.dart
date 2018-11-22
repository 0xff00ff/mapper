import 'dart:mirrors';
import 'package:mapper/src/parser.dart';

T decode<T>(Map<String, dynamic> obj) {
  final cls = reflectClass(T);
  final result =  fromMap(obj, cls);
  if (result is T) {
    return result;
  }
  return null;
}

Object fromMap(Map<String, dynamic> arg, ClassMirror cl) {
  final inst = cl.newInstance(const Symbol(''), <dynamic>[]);
  cl.declarations.forEach((key, declaration) {
    if (declaration is VariableMirror) {
      fillProp(declaration, inst, arg);
    }
  });
  return inst.reflectee;
}

void fillFromMap(Map<String, dynamic> arg, InstanceMirror inst) {
  final cl = inst.type;
  cl.declarations.forEach((key, declaration) {
    if (declaration is VariableMirror) {
      fillProp(declaration, inst, arg);
    }
  });
}

fillProp(VariableMirror declaration, InstanceMirror inst, Map<String, dynamic> arg) {
  final name = declaration.simpleName;
  if (arg != null && arg.containsKey(MirrorSystem.getName(name))) {
    final argType = arg[MirrorSystem.getName(name)].runtimeType.toString();
    final type = MirrorSystem.getName(declaration.type.simpleName);
    final val = arg[MirrorSystem.getName(name)];
    if (parsers.containsKey(type)) {
      final raw = arg[MirrorSystem.getName(name)];
      final val = parsers[type].decode(raw);
      inst.setField(name, val);
    } else if (['String', 'int', 'double', 'bool'].contains(type)) {
      if (argType == type) {
        inst.setField(name, arg[MirrorSystem.getName(name)]);
      }
    } else if (val is List) {
      if (type == 'List') {
        inst.setField(name, fillList(val));
      } else {
        inst.setField(name, []);
      }
    } else if (val is DateTime && type == 'DateTime') {
      inst.setField(name, val);
    } else if (val is Map && type == 'Map') {
      inst.setField(name, fillMap(val));
    } else {
      final ClassMirror elem = declaration.type;
      
      final Map<String, dynamic> obj2 = arg[MirrorSystem.getName(name)];
      if (null != obj2) {
        final Object local = fromMap(obj2, elem);
        inst.setField(name, local);
      }
    }
    
  }
}

List<dynamic> fillList(List<dynamic> list) {
  final List<dynamic> result = [];
  for (var q = 0; q < list.length; q++) {
    result.add(list[q]);
  }
  return result;
}

Map<dynamic, dynamic> fillMap(Map map) {
  final result = <dynamic, dynamic> {};
  map.forEach((dynamic key, dynamic value) {
    result[key] = value;
  });
  return result;
}