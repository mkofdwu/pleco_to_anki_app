import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/models_rx/rx_deck.dart';
import 'package:pleco_to_anki/services/converter_service.dart';
import 'package:pleco_to_anki/services/services.dart';

class DeckController extends GetxController {
  final RxDeck deck;

  final AnkiService anki = Get.find();
  final ConverterService converter = Get.find();

  DeckController(this.deck);

  Future<void> convertToAnki() async {
    // select the pleco export file
    // generate the anki package
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['txt'],
      type: FileType.custom,
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      final lines = await file.readAsLines();
      final notesHTML = converter.plecoToAnki(lines);
      int count = 0;
      for (final entry in notesHTML.entries) {
        if (!(await anki.isPhraseInModel(entry.key))) {
          await anki.createNote(deck.id, entry.key, entry.value);
          count++;
        }
      }
      Get.rawSnackbar(
        icon: const Icon(Icons.check, size: 20, color: Colors.white),
        shouldIconPulse: false,
        message: "Successfully imported $count new pleco flashcards!",
      );
    }
  }
}
