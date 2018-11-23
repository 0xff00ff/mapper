import 'dart:mirrors';
import 'package:mapper/src/parser.dart';
import 'package:mapper/src/mirrorcache.dart';

Map<String, dynamic> encode(Object obj) {
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

    if (item.property.ignore) {
      return;
    }

    final name = item.simpleName;
    final mapName = item.property.name ?? item.name;


    final value = obj.getField(item.simpleName).reflectee;
    if (parsers.containsKey(item.type)) {
      final val = parsers[item.type].encode(value);
      result[mapName] = val;
    } else if (null == value) {
      result[mapName] = null;
    } else if (['String', 'int', 'double', 'bool'].contains(item.type)) {
      result[mapName] = value;
    } else if (item.type == 'List') {
      result[mapName] = value;
    } else if (item.type == 'Map') {
      result[mapName] = value;
    } else if (item.type == 'DateTime') {
      DateTime date = value;
      result[mapName] = date.toIso8601String();
    } else {
      result[mapName] = toMap(obj.getField(item.simpleName));
    }
  });
  return result;
}


