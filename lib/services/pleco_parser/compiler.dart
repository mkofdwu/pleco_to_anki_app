import 'models.dart';

const tonedVowels = {
  'a': 'āáǎà',
  'e': 'ēéěè',
  'i': 'īíǐì',
  'o': 'ōóǒò',
  'u': 'ūúǔù',
  'ü': 'ǖǘǚǜ',
};

String prettifyPinyinSingle(String pinyin) {
  final spelling = pinyin.substring(0, pinyin.length - 1);
  final tone = int.parse(pinyin[pinyin.length - 1]) - 1;
  if (tone == 4) {
    return spelling;
  }
  if (spelling.endsWith('iu')) {
    return spelling.substring(0, spelling.length - 1) + tonedVowels['u']![tone];
  }
  if (spelling.endsWith('ui')) {
    return spelling.substring(0, spelling.length - 1) + tonedVowels['i']![tone];
  }
  for (final vowel in ['a', 'e', 'i', 'o', 'u']) {
    int index = spelling.indexOf(vowel);
    if (index != -1) {
      return spelling.substring(0, index) +
          tonedVowels[vowel]![tone] +
          spelling.substring(index + 1);
    }
  }
  // impossible to reach here
  return spelling;
}

String prettifyPinyin(String pinyin) {
  // convert notation such as shu4 to shù
  return RegExp('[a-zü]+[1-5]')
      .allMatches(pinyin.toLowerCase())
      .map((match) => prettifyPinyinSingle(match.group(0)!))
      .join(' ');
}

class PhraseCompiler {
  // complies to html
  final Phrase phrase;
  int cur = 0;
  bool hasUnclosedListItem = false;

  PhraseCompiler(this.phrase);

  TextItem peek() {
    return phrase.textItems[cur];
  }

  TextItem consume() {
    return phrase.textItems[cur++];
  }

  String compileToHTML() {
    return '''<div class="card">
<h1 class="chinese">${phrase.chinese}</h1>
<h2>${prettifyPinyin(phrase.pinyin)}</h2>
${compileTextItems()}
</div>''';
  }

  String compileTextItems() {
    String result = '';
    while (cur < phrase.textItems.length) {
      result += compileTextItem(phrase.textItems[cur++]);
    }
    return result;
  }

  String compileTextItem(TextItem item) {
    if (item is SimpleText) {
      return '<span>${item.text}</span>';
    }
    if (item is WordClass) {
      return '<span class="tags">${item.name}</span>';
    }
    if (item is ListItemIndicator) {
      String result = '<li><span class="list-index">${item.index}</span>';
      if (peek() is WordClass) {
        result += compileTextItem(consume());
        if (peek() is SimpleText) {
          result += compileTextItem(consume());
        }
      } else if (peek() is SimpleText) {
        result += compileTextItem(consume());
      }
      result += '</li>';
      return result;
    }
    if (item is Example) {
      return '''<div class="example">
    <div class="bullet-point"></div>
    <div class="example-column">
    <span class="chinese">${item.chinese}</span>
    <span class="pinyin">${item.pinyin}</span>
    <span class="definition">${item.english}</span>
    </div>
</div>''';
    }
    throw 'Unknown TextItem: ${item.runtimeType}';
  }
}
