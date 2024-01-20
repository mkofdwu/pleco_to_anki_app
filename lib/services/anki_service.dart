import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/services/anki/note_css.dart';
import 'package:pleco_to_anki/models_static/deck.dart';

class AnkiService extends GetxService {
  static const theModelName = 'pleco_to_anki model 6';
  static const ankiPerms = 'com.ichi2.anki.permission.READ_WRITE_DATABASE';
  static const platform = MethodChannel('com.example.pleco_to_anki/ankidroid');

  bool _canReadDb = false;
  int _theModelId = -1;

  bool get canReadDb => _canReadDb;

  Future<AnkiService> init() async {
    _canReadDb =
        (await platform.invokeMethod<bool>('requestPermission')) ?? false;
    await _initTheModel();
    return this;
  }

  Future<void> _initTheModel() async {
    if (!_canReadDb) return;

    try {
      _theModelId = (await platform.invokeMapMethod<int, String>('modelList'))!
          .entries
          .firstWhere((el) => el.value == theModelName)
          .key;
    } on StateError {
      _theModelId = (await platform.invokeMethod<int>('addNewCustomModel', {
        'name': theModelName,
        'fields': ['Front', 'Back'],
        'cards': ['Card 1'],
        'qfmt': ['<span class="very-large center">{{Front}}</span>'],
        'afmt': ['{{Back}}'],
        'css': ankiNoteCSS,
        'did': null,
        'sortf': null,
      }))!;
    }
  }

  Future<List<Deck>> getDecks() async {
    if (!_canReadDb) return [];

    final result = await platform.invokeMapMethod<int, String>('deckList');
    final decks = <Deck>[];
    for (final entry in result!.entries) {
      if (entry.key == 1) {
        // exclude default deck
      } else {
        // ankidroid java api doesnt let me find the number of notes in a deck fsr
        decks.add(Deck(id: entry.key, name: entry.value, numPhrases: 0));
      }
    }
    return decks;
  }

  Future<Deck> createDeck(String name) async {
    if (!_canReadDb) return const Deck(id: -1, name: '', numPhrases: 0);

    final id =
        await platform.invokeMethod<int>('addNewDeck', {"deckName": name});
    return Deck(id: id!, name: name, numPhrases: 0);
  }

  Future<bool> isPhraseInModel(String phrase) async {
    if (!_canReadDb) return false;

    final notes = await platform.invokeListMethod(
      'findDuplicateNotesWithKey',
      {'mid': _theModelId, 'key': phrase},
    );
    return notes!.isNotEmpty;
  }

  Future<void> createNote(int deckId, String front, String back) async {
    if (!_canReadDb) return;

    await platform.invokeMethod('addNote', {
      'modelId': _theModelId,
      'deckId': deckId,
      'fields': [front, back],
      'tags': [],
    });
  }
}
