import 'dart:mirrors';

newFromObject(Object obj) {
  final InstanceMirror objMirror = reflect(obj);
  final ClassMirror cls = objMirror.type;
  final result = cls.newInstance(const Symbol(''), <dynamic>[]);
  return result.reflectee;
}
