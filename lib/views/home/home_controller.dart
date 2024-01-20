import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/models_rx/rx_deck.dart';
import 'package:pleco_to_anki/services/services.dart';
import 'package:pleco_to_anki/views/deck/deck_view.dart';
import 'package:pleco_to_anki/views/home/new_deck_bottom_sheet.dart';

class HomeController extends GetxController {
  List<RxDeck> decks = [];

  final AnkiService anki = Get.find();

  @override
  Future<void> onInit() async {
    super.onInit();
    decks = (await anki.getDecks()).map((c) => RxDeck(c)).toList();
    update();

    if (!anki.canReadDb) {
      Get.rawSnackbar(
        icon: const Icon(Icons.error, size: 20, color: Colors.white),
        shouldIconPulse: false,
        message: "We can't read the anki database",
      );
    }
  }

  void viewDeck(int i) {
    Get.to(DeckView(deck: decks[i]));
  }

  Future<void> newDeck() async {
    final deck = await Get.bottomSheet(const NewDeckBottomSheet());
    if (deck != null) {
      decks.add(RxDeck(deck));
      update();
    }
  }
}
