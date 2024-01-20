import 'package:get/get.dart';
import 'package:pleco_to_anki/models_static/deck.dart';

class RxDeck {
  final int id;
  final RxString name;
  final RxInt numPhrases;

  RxDeck(Deck deck)
      : id = deck.id,
        name = deck.name.obs,
        numPhrases = deck.numPhrases.obs;
}
