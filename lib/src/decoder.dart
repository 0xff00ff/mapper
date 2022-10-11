import 'dart:mirrors';
import 'package:mapper/src/parser.dart';
import 'package:mapper/src/mirrorcache.dart';

/// decodes a map into an Class
T? decode<T>(Map<String, dynamic> obj) {
  final cls = reflectClass(T);
  final result = _fromMap(obj, cls);
  if (result is T) {
    return result as T;
  }
  return null;
}

Object _fromMap(Map<String, dynamic> arg, ClassMirror cl) {
  final inst = cl.newInstance(const Symbol(''), <dynamic>[]);

  ClassMirror cls = inst.type;
  if (!mirrorCache.containsKey(cls.simpleName)) {
    fillCachedItems(cls);
  }

  final List<CacheItem> items = mirrorCache[cls.simpleName]!;

  items.forEach((CacheItem item) {
    _fillProp(item, inst, arg);
  });
  return inst.reflectee;
}

void _fillFromMap(Map<String, dynamic> arg, InstanceMirror inst) {
  ClassMirror cls = inst.type;
  if (!mirrorCache.containsKey(cls.simpleName)) {
    fillCachedItems(cls);
  }
  final List<CacheItem> items = mirrorCache[cls.simpleName]!;

  // cl.declarations.forEach((key, declaration) {
  items.forEach((CacheItem item) {
    _fillProp(item, inst, arg);
  });
}

_fillProp(CacheItem declaration, InstanceMirror inst, Map<String, dynamic> arg) {

  if (declaration.property!.ignore) {
    return;
  }

  final name = declaration.simpleName;
  final mapName = declaration.property!.name ?? declaration.name;

  if (arg.containsKey(mapName)) {
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
        inst.setField(name, val);
      } else {
        inst.setField(name, []);
      }
    } else if (val is DateTime && declaration.type == 'DateTime') {
      inst.setField(name, val);
    } else if (val is Map && declaration.type == 'Map') {
      inst.setField(name, val);
    } else {
      final ClassMirror elem = declaration.declarationType;

      final Map<String, dynamic> obj2 = arg[mapName];
      final Object local = _fromMap(obj2, elem);
      inst.setField(name, local);
    }
  }
}

List<dynamic> _fillList<T>(List<dynamic> list) {
  final List<T> result = [];
  for (var q = 0; q < list.length; q++) {
    result.add(list[q]);
  }
  return result;
}

Map<dynamic, dynamic> _fillMap(Map map) {
  final result = <dynamic, dynamic>{};
  map.forEach((dynamic key, dynamic value) {
    result[key] = value;
  });
  return result;
}
