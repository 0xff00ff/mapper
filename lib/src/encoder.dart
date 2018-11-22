import 'dart:mirrors';
import 'package:mapper/src/parser.dart';

class CacheItem {
  final String name;
  final String type;
  final Symbol simpleName;

  const CacheItem(this.name, this.type, this.simpleName);
}

final Map<Symbol, List<CacheItem>> mirrorCache = {};

Map <String, dynamic> encode(Object obj) {
  final objMirror = reflect(obj);
  return toMap(objMirror);
}

Map<String, dynamic> toMap(InstanceMirror obj) {
  final result = <String, dynamic>{};
  ClassMirror cls = obj.type;
  if (!mirrorCache.containsKey(cls.simpleName)) {
    fillCachedItems(cls);
  }

  final List<CacheItem> items = mirrorCache[cls.simpleName];

  items.forEach((CacheItem item) {
      final value = obj.getField(item.simpleName).reflectee;
      if (parsers.containsKey(item.type)) {
        final val = parsers[item.type].encode(value);
        result[item.name] = val;
      } else if (null == value) {
        result[item.name] = null;
      } else if (['String', 'int', 'double', 'bool'].contains(item.type)) {
        result[item.name] = value;
      } else if (item.type == 'List') {
        result[item.name] = value;
      } else if (item.type == 'Map') {
        result[item.name] = value;
      } else if (item.type == 'DateTime') {
        DateTime date = value;
        result[item.name] = date.toIso8601String();
      } else {
        result[item.name] = toMap(obj.getField(item.simpleName));
      }
  });
  return result;
} 

void fillCachedItems(ClassMirror cls) {
  final List<CacheItem> items = [];
  cls.declarations.forEach((key, declaration) {
    if (declaration is VariableMirror) {
      String name = MirrorSystem.getName(declaration.simpleName);
      final type = MirrorSystem.getName(declaration.type.simpleName);
      items.add(new CacheItem(name, type, declaration.simpleName));
    }
  });
  mirrorCache[cls.simpleName] = items;
}