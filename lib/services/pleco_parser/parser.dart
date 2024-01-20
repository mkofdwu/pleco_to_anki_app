import 'models.dart';

int countBrackets(String word) {
  int count = 0;
  for (int i = 0; i < word.length; i++) {
    if (word[i] == '(') {
      count++;
    } else if (word[i] == ')') {
      count--;
    }
  }
  return count;
}

class PhraseParser {
  // parses single line in pleco export file

  static const plecoWordClasses = [
    'verb',
    'adjective',
    'noun',
    'idiom',
    'conjunction',
    'literary',
    'dialect',
    'colloquial',
    'adverb',
    'pronoun',
    'preposition',
    'pejorative',
    'euphemistic'
  ];
  static final numberRegexPattern = RegExp('^[0-9]+\$');
  static final chineseCharPattern = RegExp('^[\u4e00-\u9fff]');
  static const tonedPinyinChars = 'āáǎàēéěèīíǐìōóǒòūúǔùüǖǘǚǜ';
  static const pinyinChars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$tonedPinyinChars';

  final String src;
  int cur = 0;

  PhraseParser(this.src);

  String consumeWord() {
    final start = cur;
    while (cur < src.length && !' \t'.contains(src[cur])) {
      cur++;
    }
    final word = src.substring(start, cur);
    // consume remaining whitespace
    while (cur < src.length && ' \t'.contains(src[cur])) {
      cur++;
    }
    return word;
  }

  String consumeSimpleText() {
    final start = cur;

    int prevCur = cur;
    int openBrackets = 0;
    String word = consumeWord();
    // break if reached end
    // break if all brackets are closed and hit non standard text
    while (true) {
      if (word.isEmpty) break;

      if (openBrackets <= 0 &&
          (plecoWordClasses.contains(word) ||
              numberRegexPattern.hasMatch(word) ||
              chineseCharPattern.hasMatch(word))) break;

      openBrackets += countBrackets(word);

      prevCur = cur;
      word = consumeWord();
    }

    cur = prevCur;
    return src.substring(start, cur).trimRight();
  }

  Phrase parsePhrase() {
    final chinese = consumeWord();
    final pinyin = consumeWord();
    final textItems = parseTextItems();
    return Phrase(
      chinese: chinese,
      pinyin: pinyin,
      textItems: textItems,
    );
  }

  List<TextItem> parseTextItems() {
    final textItems = <TextItem>[];

    String word;
    while (cur < src.length - 1) {
      word = consumeWord();
      if (plecoWordClasses.contains(word)) {
        textItems.add(WordClass(name: word));
      } else if (numberRegexPattern.hasMatch(word)) {
        textItems.add(ListItemIndicator(index: word));
      } else if (chineseCharPattern.hasMatch(word)) {
        textItems.add(parseExample(word));
      } else {
        textItems.add(SimpleText(text: '$word ${consumeSimpleText()}'));
      }
    }

    return textItems;
  }

  Example parseExample(String chinese) {
    int prevCur = cur;
    String word = consumeWord();
    while (chineseCharPattern.hasMatch(word)) {
      chinese += word;
      prevCur = cur;
      word = consumeWord();
    }
    cur = prevCur;

    // pinyin and translation
    final pinyinAndEnglish = consumeSimpleText();

    // reasonable approximation: find the last pinyin word with a tone and set
    // that as the boundary. Won't work for toneless pinyin such as le
    final i = splitPinyinAndEnglish(pinyinAndEnglish);
    final pinyin = pinyinAndEnglish.substring(0, i).trimRight();
    final english = pinyinAndEnglish.substring(i, pinyinAndEnglish.length);
    return Example(
      chinese: chinese,
      pinyin: pinyin,
      english: english,
    );
  }

  int splitPinyinAndEnglish(String pinyinAndEnglish) {
    int splitAt = 0;
    for (int i = pinyinAndEnglish.length - 1; i > -1; i--) {
      if (pinyinAndEnglish[i] == ' ') {
        splitAt = i + 1;
      } else if (tonedPinyinChars.contains(pinyinAndEnglish[i])) {
        break;
      }
    }
    return splitAt;
  }
}
