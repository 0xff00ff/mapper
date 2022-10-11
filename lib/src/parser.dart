final parsers = <String, Parser>{};

addParser(String type, Parser parser) {
  parsers[type] = parser;
}

abstract class Parser {
  encode(dynamic srg);
  decode(dynamic arg);
}
