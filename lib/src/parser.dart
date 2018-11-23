final parsers = <String, Parser>{};

addParser(String type, Parser parser) {
  parsers[type] = parser;
}

abstract class Parser {
  encode(srg);
  decode(arg);
}
