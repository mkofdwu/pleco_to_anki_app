import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/services/services.dart';

class NewDeckController extends GetxController {
  final TextEditingController textController = TextEditingController();

  final AnkiService anki = Get.find();

  Future<void> submit() async {
    if (textController.text.isNotEmpty) {
      final deck = await anki.createDeck(textController.text);
      Get.back(result: deck);
    }
  }
}
