import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pleco_to_anki/constants/palette.dart';
import 'package:pleco_to_anki/models_rx/rx_deck.dart';
import 'package:pleco_to_anki/widgets/button.dart';
import 'package:pleco_to_anki/widgets/pressed_builder.dart';

import 'deck_controller.dart';

class DeckView extends StatelessWidget {
  final RxDeck deck;

  const DeckView({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeckController>(
      init: DeckController(deck),
      builder: (controller) => Scaffold(
        body: Column(
          children: [
            _detailSheet(controller),
            Expanded(
              child: Obx(
                () => controller.numToProcess.value > 0
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 64,
                            height: 64,
                            child: CircularProgressIndicator(
                              value: controller.numProcessed.value /
                                  controller.numToProcess.value,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Importing ${controller.numProcessed.value}/${controller.numToProcess.value}',
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return Transform.translate(
      offset: const Offset(-9, -7),
      child: PressedBuilder(
        onPressed: Get.back,
        animationDuration: 100,
        builder: (pressed) => Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(pressed ? 0.1 : 0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back, size: 20),
              SizedBox(width: 8),
              Text(
                'BACK',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailSheet(DeckController controller) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      decoration: const BoxDecoration(
        color: Palette.black1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _backButton(),
            const SizedBox(height: 48),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deck.name.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Text(
                  //   '${deck.numPhrases}',
                  //   style: const TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            MyButton(
              text: 'Add from pleco',
              onPressed: controller.convertToAnki,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Note: phrases already in anki will not be added again.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
