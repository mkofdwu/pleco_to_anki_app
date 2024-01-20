import 'package:get/get.dart';
import 'package:pleco_to_anki/services/pleco_parser/compiler.dart';
import 'package:pleco_to_anki/services/pleco_parser/parser.dart';

import 'pleco_parser/models.dart';

class ConverterService extends GetxService {
  Map<String, String> plecoToAnki(List<String> lines) {
    final result = <String, String>{};
    for (final line in lines) {
      Phrase phrase = PhraseParser(line).parsePhrase();
      final html = PhraseCompiler(phrase).compileToHTML();
      result[phrase.chinese] = html;
    }
    return result;
  }
}
