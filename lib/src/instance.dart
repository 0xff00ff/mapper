import 'dart:mirrors';

/// Creates new reflectee from object
newFromObject(Object obj) {
  final InstanceMirror objMirror = reflect(obj);
  final ClassMirror cls = objMirror.type;
  final result = cls.newInstance(const Symbol(''), <dynamic>[]);
  return result.reflectee;
}
