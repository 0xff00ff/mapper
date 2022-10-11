class Entity {
  final bool fullMatch;

  const Entity({this.fullMatch = false});
}

class Property {
  final String? name;
  final bool ignore;

  const Property({this.name = null, this.ignore = false});
}