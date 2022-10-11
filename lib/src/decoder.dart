import 'dart:mirrors';
import 'package:mapper/src/parser.dart';
import 'package:mapper/src/mirrorcache.dart';

T? decode<T>(Map<String, dynamic> obj) {
  final cls = reflectClass(T);
  final result = fromMap(obj, cls);
  if (result is T) {
    return result as T;
  }
  return null;
}

Object fromMap(Map<String, dynamic> arg, ClassMirror cl) {
  final inst = cl.newInstance(const Symbol(''), <dynamic>[]);

  ClassMirror cls = inst.type;
  if (!mirrorCache.containsKey(cls.simpleName)) {
    fillCachedItems(cls);
  }

  final List<CacheItem> items = mirrorCache[cls.simpleName]!;

  items.forEach((CacheItem item) {
    fillProp(item, inst, arg);
  });
  return inst.reflectee;
}

void fillFromMap(Map<String, dynamic> arg, InstanceMirror inst) {
  ClassMirror cls = inst.type;
  if (!mirrorCache.containsKey(cls.simpleName)) {
    fillCachedItems(cls);
  }
  final List<CacheItem> items = mirrorCache[cls.simpleName]!;

  // cl.declarations.forEach((key, declaration) {
  items.forEach((CacheItem item) {
    fillProp(item, inst, arg);
  });
}

fillProp(CacheItem declaration, InstanceMirror inst, Map<String, dynamic> arg) {

  if (declaration.property!.ignore) {
    return;
  }

  final name = declaration.simpleName;
  final mapName = declaration.property!.name ?? declaration.name;

  if (arg != null && arg.containsKey(mapName)) {
    final argType = arg[mapName].runtimeType.toString();
    final val = arg[declaration.name];
    if (parsers.containsKey(declaration.type)) {
      final raw = arg[mapName];
      final val = parsers[declaration.type]!.decode(raw);
      inst.setField(name, val);
    } else if (declaration.type == 'dynamic') {
      inst.setField(name, arg[mapName]);
    } else if (['String', 'int', 'double', 'bool'].contains(declaration.type)) {
      if (argType == declaration.type) {
        inst.setField(name, arg[mapName]);
      }
    } else if (val is List) {
      if (declaration.type == 'List') {
        inst.setField(name, fillList(val));
      } else {
        inst.setField(name, []);
      }
    } else if (val is DateTime && declaration.type == 'DateTime') {
      inst.setField(name, val);
    } else if (val is Map && declaration.type == 'Map') {
      inst.setField(name, fillMap(val));
    } else {
      final ClassMirror elem = declaration.declarationType;

      final Map<String, dynamic> obj2 = arg[mapName];
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
  final result = <dynamic, dynamic>{};
  map.forEach((dynamic key, dynamic value) {
    result[key] = value;
  });
  return result;
}
