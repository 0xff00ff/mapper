final parsers = <String, Parser>{};

/// adds new custom parser to parsers list
addParser(String type, Parser parser) {
  parsers[type] = parser;
}

/// custom parser interface
abstract class Parser {
  encode(dynamic srg);
  decode(dynamic arg);
}
