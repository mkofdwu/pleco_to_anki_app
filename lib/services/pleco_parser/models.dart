abstract class TextItem {}

class WordClass extends TextItem {
  final String name;

  WordClass({required this.name});
}

class SimpleText extends TextItem {
  // probably definition
  final String text;

  SimpleText({required this.text});
}

class ListItemIndicator extends TextItem {
  final String index;

  ListItemIndicator({required this.index});
}

class Example extends TextItem {
  final String chinese;
  final String pinyin;
  final String english;

  Example({
    required this.chinese,
    required this.pinyin,
    required this.english,
  });
}

class Phrase {
  final String chinese;
  final String pinyin;
  final List<TextItem> textItems;

  Phrase({
    required this.chinese,
    required this.pinyin,
    required this.textItems,
  });
}
