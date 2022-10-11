import 'dart:mirrors';
import 'package:mapper/src/meta.dart';

class CacheItem {
  final String name;
  final String type;
  final Symbol simpleName;
  final ClassMirror declarationType;
  final Property? property;
  final bool useAnyWay;

  const CacheItem(this.name, this.type, this.simpleName, this.declarationType, {this.property = null, this.useAnyWay = false});
}

final Map<Symbol, List<CacheItem>> mirrorCache = {};

void fillCachedItems(ClassMirror cls) {

  var useAnyWay = false;
  cls.metadata.forEach((InstanceMirror itemMeta){
    if (itemMeta.reflectee is Entity) {
      if (itemMeta.reflectee.fullMatch) {
        useAnyWay = true;
      }
    }
  });

  final List<CacheItem> items = [];
  cls.declarations.forEach((key, declaration) {
    if (declaration is VariableMirror) {
      String name = MirrorSystem.getName(declaration.simpleName);
      final type = MirrorSystem.getName(declaration.type.simpleName);

      Property propMeta;
      // check meta
      declaration.metadata.forEach((InstanceMirror metaItem){
        if (metaItem.reflectee is Property) {
          propMeta = metaItem.reflectee;
        }
      });

      propMeta = new Property(ignore: !useAnyWay);

      items.add(new CacheItem(name, type, declaration.simpleName, declaration.type as ClassMirror, property: propMeta, useAnyWay: useAnyWay));
    }
  });
  mirrorCache[cls.simpleName] = items;
}