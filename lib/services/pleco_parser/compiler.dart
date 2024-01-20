import 'models.dart';

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
<h2>${phrase.pinyin}</h2>
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
      String result = '<div><span class="list-index">${item.index}</span>';
      if (peek() is WordClass) {
        result += compileTextItem(consume());
        if (peek() is SimpleText) {
          result += compileTextItem(consume());
        }
      } else if (peek() is SimpleText) {
        result += compileTextItem(consume());
      }
      result += '</div>';
      return result;
    }
    if (item is Example) {
      return '''<li class="example">
    <div class="bullet-point"></div>
    <div class="example-column">
    <span class="chinese">${item.chinese}</span>
    <span class="pinyin">${item.pinyin}</span>
    <span class="definition">${item.english}</span>
    </div>
</li>''';
    }
    throw 'Unknown TextItem: ${item.runtimeType}';
  }
}
